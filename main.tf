module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

module "packer" {
  create = var.create

  source = "github.com/insight-infrastructure/terraform-packer-build.git"

  packer_config_path = "${path.module}/packer.json"
  timestamp_ui       = true
  vars = {
    module_path = path.module,

    azure_resource_group_name = var.azure_resource_group_name,

    client_id : var.client_id,
    client_secret : var.client_secret,
    subscription_id : var.subscription_id,
    node_exporter_user : var.node_exporter_user,
    node_exporter_password : var.node_exporter_password,
    chain : var.chain,
    ssh_user : var.ssh_user,
    project : var.project,
    location : data.azurerm_resource_group.this.location,
    polkadot_binary_url : "https://github.com/w3f/polkadot/releases/download/v0.7.21/polkadot",
    polkadot_binary_checksum : "sha256:af561dc3447e8e6723413cbeed0e5b1f0f38cffaa408696a57541897bf97a34d",
    node_exporter_binary_url : "https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz",
    node_exporter_binary_checksum : "sha256:b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424",
    polkadot_restart_enabled : true,
    polkadot_restart_minute : "50",
    polkadot_restart_hour : "10",
    polkadot_restart_day : "1",
    polkadot_restart_month : "*",
    polkadot_restart_weekday : "*",
    telemetry_url : var.telemetry_url,
    logging_filter : var.logging_filter,
    relay_ip_address : var.relay_node_ip,
    relay_p2p_address : var.relay_node_p2p_address,
    consul_datacenter : data.azurerm_resource_group.this.location,
    consul_enabled : var.consul_enabled,
    prometheus_enabled : var.prometheus_enabled,
    retry_join : "\"provider=azure tenant_id=${var.tenant_id} client_id=${var.client_id} subscription_id=${var.subscription_id} secret_access_key=\"${var.client_secret}\" resource_group=${var.k8s_resource_group} vm_scale_set=${var.k8s_scale_set}\""
  }
}


data "azurerm_resource_group" "this" {
  name = var.azure_resource_group_name
}

data "azurerm_image" "this" {
  name                = "packer-sentry"
  resource_group_name = data.azurerm_resource_group.this.name
  depends_on          = [module.packer]
  sort_descending     = true
}

module "user_data" {
  source              = "github.com/insight-w3f/terraform-polkadot-user-data.git?ref=master"
  cloud_provider      = "azure"
  type                = "library"
  consul_enabled      = var.consul_enabled
  prometheus_enabled  = var.prometheus_enabled
  prometheus_user     = var.node_exporter_user
  prometheus_password = var.node_exporter_password
}

resource "azurerm_linux_virtual_machine_scale_set" "sentry" {
  count               = var.create ? 1 : 0
  name                = "polkadot-sentry"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  sku                 = var.instance_type
  instances           = var.num_instances
  admin_username      = "ubuntu"
  custom_data         = base64encode(module.user_data.user_data)

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(var.public_key_path)
  }

  source_image_id = data.azurerm_image.this.id

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  data_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = 256
    lun                  = 0
  }

  network_interface {
    name                      = "Public"
    primary                   = true
    network_security_group_id = var.network_security_group_id

    ip_configuration {
      name                                   = "Public"
      primary                                = true
      application_security_group_ids         = [var.application_security_group_id]
      subnet_id                              = var.public_subnet_id
      load_balancer_backend_address_pool_ids = [var.lb_backend_pool_id]
    }
  }

  network_interface {
    name                      = "Private"
    network_security_group_id = var.network_security_group_id

    ip_configuration {
      name                           = "Private"
      application_security_group_ids = [var.application_security_group_id]
      subnet_id                      = var.private_subnet_id
    }
  }
}