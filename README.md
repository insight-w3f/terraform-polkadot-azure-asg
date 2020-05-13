# terraform-polkadot-azure-asg

[![open-issues](https://img.shields.io/github/issues-raw/insight-w3f/terraform-polkadot-azure-asg?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-azure-asg/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-w3f/terraform-polkadot-azure-asg?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-azure-asg/pulls)
[![build-status](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-asg.svg?style=svg)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-asg)


## Features

This module...

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
    source = "github.com/insight-w3f/terraform-polkadot-azure-asg"

}
```
## Examples

- [defaults](https://github.com/insight-w3f/terraform-polkadot-azure-asg/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_security\_group\_id | The id of the application security group to run in | `string` | n/a | yes |
| azure\_resource\_group\_name | Name of Azure Resource Group | `string` | n/a | yes |
| chain | Which Polkadot chain to join | `string` | `"kusama"` | no |
| client\_id | Azure SP for Packer ID | `string` | n/a | yes |
| client\_secret | Azure SP for Packer secret | `string` | n/a | yes |
| cluster\_name | The name of the k8s cluster | `string` | `""` | no |
| consul\_enabled | Bool to use when Consul is enabled | `bool` | `false` | no |
| create | Bool to create the resources | `bool` | `true` | no |
| environment | The environment | `string` | `""` | no |
| instance\_type | Instance type | `string` | `"Standard_A2_v2"` | no |
| k8s\_resource\_group | Name of resource group where kubernetes cluster resources are | `string` | `""` | no |
| k8s\_scale\_set | Name of kubernetes worker scale set | `string` | `""` | no |
| key\_name | The name of the preexisting key to be used instead of the local public\_key\_path | `string` | `""` | no |
| lb\_backend\_pool\_id | The ID of the load balancer backend IP pool | `string` | n/a | yes |
| logging\_filter | String for polkadot logging filter | `string` | `"sync=trace,afg=trace,babe=debug"` | no |
| namespace | The namespace to deploy into | `string` | `""` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `""` | no |
| network\_security\_group\_id | The id of the network security group to run in | `string` | n/a | yes |
| node\_exporter\_hash | SHA256 hash of Node Exporter binary | `string` | `"b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424"` | no |
| node\_exporter\_password | Password for node exporter | `string` | `"node_exporter_password"` | no |
| node\_exporter\_url | URL to Node Exporter binary | `string` | `"https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz"` | no |
| node\_exporter\_user | User for node exporter | `string` | `"node_exporter_user"` | no |
| num\_instances | Number of instances for ASG | `number` | `1` | no |
| owner | Owner of the infrastructure | `string` | `""` | no |
| polkadot\_client\_hash | SHA256 hash of Polkadot client binary | `string` | `"c34d63e5d80994b2123a3a0b7c5a81ce8dc0f257ee72064bf06654c2b93e31c9"` | no |
| polkadot\_client\_url | URL to Polkadot client binary | `string` | `"https://github.com/w3f/polkadot/releases/download/v0.7.32/polkadot"` | no |
| private\_subnet\_id | The id of the subnet. | `string` | n/a | yes |
| project | Name of the project for node name | `string` | `"project"` | no |
| prometheus\_enabled | Bool to use when Prometheus is enabled | `bool` | `false` | no |
| public\_key\_path | The path to the public ssh key | `string` | n/a | yes |
| public\_subnet\_id | The id of the subnet. | `string` | n/a | yes |
| relay\_node\_ip | Internal IP of Polkadot relay node | `string` | `""` | no |
| relay\_node\_p2p\_address | P2P address of Polkadot relay node | `string` | `""` | no |
| ssh\_user | Username for SSH | `string` | `"ubuntu"` | no |
| stage | The stage of the deployment | `string` | `""` | no |
| subscription\_id | Azure subscription ID | `string` | n/a | yes |
| telemetry\_url | WSS URL for telemetry | `string` | `""` | no |
| tenant\_id | Azure Tenant ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cmd | n/a |
| scale\_set\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [Richard Mah](https://github.com/shinyfoil)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.