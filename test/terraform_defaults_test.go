package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"io/ioutil"
	"log"
	"os"
	"path"
	"strconv"
	"strings"
	"testing"
	"time"
)

func TestTerraformDefaults(t *testing.T) {
	t.Parallel()

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/defaults")

	cwd, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}

	fixturesDir := path.Join(cwd, "fixtures")
	privateKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test")
	publicKeyPath := path.Join(fixturesDir, "./keys/id_rsa_test.pub")
	generateKeys(privateKeyPath, publicKeyPath)
	dat, err := ioutil.ReadFile(publicKeyPath)
	if err != nil{
		panic(err)
	}
	publicKey := string(dat)

	clientId, _ := os.LookupEnv("ARM_CLIENT_ID")
	clientSecret, _ := os.LookupEnv("ARM_CLIENT_SECRET")
	subscriptionId, _ := os.LookupEnv("ARM_SUBSCRIPTION_ID")
	tenantId, _ := os.LookupEnv("ARM_TENANT_ID")

	terraformOptions := &terraform.Options{
		TerraformDir: exampleFolder,
		Vars: map[string]interface{}{
			"public_key": publicKey,
			"chain":           "dev",
			"client_id":       clientId,
			"client_secret":   clientSecret,
			"subscription_id": subscriptionId,
			"tenant_id":       tenantId,
		},
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, terraformOptions)
		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		testLbEndpoints(t, terraformOptions)
	})
}

func testLbEndpoints(t *testing.T, terraformOptions *terraform.Options) {

	loadBalancerIp := terraform.Output(t, terraformOptions, "public_ip")

	expectedStatus := "200"
	body := strings.NewReader(`{"id":1, "jsonrpc":"2.0", "method":"system_health", "params":[]}`)
	url := fmt.Sprintf("http://%s:9933", loadBalancerIp)
	headers := make(map[string]string)
	headers["Content-Type"] = "application/json"

	description := fmt.Sprintf("curl to LB %s with error command", loadBalancerIp)
	maxRetries := 30
	timeBetweenRetries := 1 * time.Second

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {

		outputStatus, _, err := http_helper.HTTPDoE(t, "POST", url, body, headers, nil)

		if err != nil {
			return "", err
		}

		if strings.TrimSpace(strconv.Itoa(outputStatus)) != expectedStatus {
			return "", fmt.Errorf("expected SSH command to return '%s' but got '%s'", expectedStatus, strconv.Itoa(outputStatus))
		}

		return "", nil
	})
}
