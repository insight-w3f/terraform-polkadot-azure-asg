provider "azurerm" {
  version = ">=2.0.0"
  features {}
}

resource "azurerm_resource_group" "this" {
  location = "eastus"
  name     = "asg-default-testing"
}

variable "client_secret" {}
variable "client_id" {}
variable "subscription_id" {}
variable "public_key" {}
variable "chain" {}
variable "tenant_id" {}

module "network" {
  source                    = "github.com/insight-w3f/terraform-polkadot-azure-network.git?ref=master"
  azure_resource_group_name = azurerm_resource_group.this.name
}

module "defaults" {
  source = "../.."

  azure_resource_group_name = azurerm_resource_group.this.name

  client_id                     = var.client_id
  client_secret                 = var.client_secret
  subscription_id               = var.subscription_id
  tenant_id                     = var.tenant_id
  private_subnet_id             = module.network.private_subnets[0]
  public_subnet_id              = module.network.public_subnets[0]
  public_key                    = var.public_key
  application_security_group_id = module.network.sentry_application_security_group_id[0]
  network_security_group_id     = module.network.public_network_security_group_id
  chain                         = var.chain
}
