provider "azurerm" {
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "this" {
  location = "eastus"
  name     = "asg-default-testing"
}

variable "client_secret" {}
variable "client_id" {}
variable "subscription_id" {}
variable "public_key_path" {}
variable "chain" {}

module "network" {
  source                    = "github.com/insight-w3f/terraform-polkadot-azure-network.git?ref=insight-w3f"
  azure_resource_group_name = azurerm_resource_group.this.name
}

module "lb" {
  source                    = "github.com/insight-w3f/terraform-polkadot-azure-api-lb.git?ref=master"
  azure_resource_group_name = azurerm_resource_group.this.name
}

module "defaults" {
  source = "../.."

  azure_resource_group_name     = azurerm_resource_group.this.name
  client_id                     = var.client_id
  client_secret                 = var.client_secret
  subscription_id               = var.subscription_id
  lb_backend_pool_id            = module.lb.lb_backend_pool_id
  relay_node_ip                 = "1.2.3.4"
  relay_node_p2p_address        = "stuffthingsstuffthingsstuffthingsstuffthingsstuffthings"
  private_subnet_id             = module.network.private_subnets[0]
  public_subnet_id              = module.network.public_subnets[0]
  public_key_path               = var.public_key_path
  application_security_group_id = module.network.sentry_application_security_group_id[0]
  network_security_group_id     = module.network.sentry_network_security_group_id[0]
  chain                         = var.chain
}
