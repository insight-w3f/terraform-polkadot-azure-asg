package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"log"
	"os"
	"path"
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

	client_id, _ := os.LookupEnv("ARM_CLIENT_ID")
	client_secret, _ := os.LookupEnv("ARM_CLIENT_SECRET")
	subscription_id, _ := os.LookupEnv("ARM_SUBSCRIPTION_ID")

	terraformOptions := &terraform.Options{
		TerraformDir: exampleFolder,
		Vars: map[string]interface{}{
			"public_key_path":    publicKeyPath,
			"chain": "dev",
			"client_id": client_id,
			"client_secret": client_secret,
			"subscription_id": subscription_id,
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

		if strings.TrimSpace(string(outputStatus)) != expectedStatus {
			return "", fmt.Errorf("expected SSH command to return '%s' but got '%s'", expectedStatus, string(outputStatus))
		}

		return "", nil
	})
}
