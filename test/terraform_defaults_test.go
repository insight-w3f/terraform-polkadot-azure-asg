package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/shell"
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

	terraformOptions := &terraform.Options{
		TerraformDir: exampleFolder,
		Vars: map[string]interface{}{
			"public_key_path":    publicKeyPath,
			"chain": "dev",
		},
	}

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		testLbEndpoints(t, terraformOptions)
	})
}

func testLbEndpoints(t *testing.T, terraformOptions *terraform.Options) {

	loadBalancerIp := terraform.Output(t, terraformOptions, "public_ip")

	cmd := fmt.Sprintf("curl -sL --data-binary '{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"system_health\", \"params\":[]}' -H 'content-type:application/json' -w %%{http_code} -o /dev/null http://%s:9933", loadBalancerIp)

	expectedStatus := "200"

	command := shell.Command{
		Command:           cmd,
		Args:              nil,
		WorkingDir:        ".",
		Env:               nil,
		OutputMaxLineSize: 0,
	}

	description := fmt.Sprintf("curl to LB %s with error command", loadBalancerIp)
	maxRetries := 30
	timeBetweenRetries := 1 * time.Second

	// Verify that we can SSH to the Instance and run commands
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {

		outputStatus, err := shell.RunCommandAndGetOutputE(t, command)

		if err != nil {
			return "", err
		}

		if strings.TrimSpace(outputStatus) != expectedStatus {
			return "", fmt.Errorf("expected SSH command to return '%s' but got '%s'", expectedStatus, outputStatus)
		}

		return "", nil
	})
}
