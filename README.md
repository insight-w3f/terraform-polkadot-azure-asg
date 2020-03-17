# terraform-polkadot-azure-asg-node

[![open-issues](https://img.shields.io/github/issues-raw/insight-infrastructure/terraform-polkadot-azure-asg-node?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-polkadot-azure-asg-node/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-infrastructure/terraform-polkadot-azure-asg-node?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-polkadot-azure-asg-node/pulls)

## Features

This module...

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
    source = "github.com/insight-infrastructure/terraform-polkadot-azure-asg-node"

}
```
## Examples

- [defaults](https://github.com/insight-infrastructure/terraform-polkadot-azure-asg-node/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| client\_id | Azure SP for Packer ID | `string` | n/a | yes |
| client\_secret | Azure SP for Packer secret | `string` | n/a | yes |
| environment | The environment | `string` | `""` | no |
| key\_name | The name of the preexisting key to be used instead of the local public\_key\_path | `string` | `""` | no |
| logging\_filter | String for polkadot logging filter | `string` | `"sync=trace,afg=trace,babe=debug"` | no |
| namespace | The namespace to deploy into | `string` | `""` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `""` | no |
| node\_exporter\_password | Password for node exporter | `string` | `"node_exporter_password"` | no |
| node\_exporter\_user | User for node exporter | `string` | `"node_exporter_user"` | no |
| owner | Owner of the infrastructure | `string` | `""` | no |
| polkadot\_chain | Which Polkadot chain to join | `string` | `"kusama"` | no |
| project | Name of the project for node name | `string` | `"project"` | no |
| public\_key\_path | The path to the public ssh key | `string` | `""` | no |
| relay\_node\_ip | Internal IP of Polkadot relay node | `string` | n/a | yes |
| relay\_node\_p2p\_address | P2P address of Polkadot relay node | `string` | n/a | yes |
| ssh\_user | Username for SSH | `string` | `"ubuntu"` | no |
| stage | The stage of the deployment | `string` | `""` | no |
| subscription\_id | Azure subscription ID | `string` | n/a | yes |
| telemetry\_url | WSS URL for telemetry | `string` | `"wss://mi.private.telemetry.backend/"` | no |
| zone | The GCP zone to deploy in | `string` | `"US East"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cmd | n/a |

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