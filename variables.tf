variable "create" {
  description = "Bool to create the resources"
  type        = bool
  default     = true
}

#####
# Azure
#####
variable "client_id" {
  description = "Azure SP for Packer ID"
  type        = string
}

variable "client_secret" {
  description = "Azure SP for Packer secret"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_resource_group_name" {
  description = "Name of Azure Resource Group"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "k8s_resource_group" {
  description = "Name of resource group where kubernetes cluster resources are"
  type        = string
  default     = ""
}

variable "k8s_scale_set" {
  description = "Name of kubernetes worker scale set"
  type        = string
  default     = ""
}


#######
# Label
#######
variable "tags" {
  description = "Tags in the form of key value pairs to associate with resources"
  type        = map(string)
  default     = {}
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

#####
# instance
#####
variable "public_key" {
  description = "The public ssh key"
  type        = string
}

variable "key_name" {
  description = "The name of the preexisting key to be used instead of the local public_key_path"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "Standard_A2_v2"
}

variable "min_size" {
  description = "The min size of asg"
  type        = string
  default     = 0
}

variable "max_size" {
  description = "The max size of asg"
  type        = string
  default     = 10
}

variable "desired_capacity" {
  description = "The desired capacity of asg"
  type        = string
  default     = 2
}

#########
# Network
#########
variable "public_subnet_id" {
  description = "The id of the subnet."
  type        = string
}

variable "private_subnet_id" {
  description = "The id of the subnet."
  type        = string
}

variable "application_security_group_id" {
  description = "The id of the application security group to run in"
  type        = string
}

variable "network_security_group_id" {
  description = "The id of the network security group to run in"
  type        = string
}

#####
# packer
#####

variable "node_exporter_user" {
  description = "User for node exporter"
  type        = string
  default     = "node_exporter_user"
}

variable "node_exporter_password" {
  description = "Password for node exporter"
  type        = string
  default     = "node_exporter_password"
}

variable "chain" {
  description = "Which Polkadot chain to join"
  type        = string
  default     = "kusama"
}

variable "project" {
  description = "Name of the project for node name"
  type        = string
  default     = "project"
}

variable "ssh_user" {
  description = "Username for SSH"
  type        = string
  default     = "ubuntu"
}

variable "telemetry_url" {
  description = "WSS URL for telemetry"
  type        = string
  default     = ""
}

variable "logging_filter" {
  description = "String for polkadot logging filter"
  type        = string
  default     = "sync=trace,afg=trace,babe=debug"
}

variable "relay_node_ip" {
  description = "Internal IP of Polkadot relay node"
  type        = string
  default     = ""
}

variable "relay_node_p2p_address" {
  description = "P2P address of Polkadot relay node"
  type        = string
  default     = ""
}

variable "consul_enabled" {
  description = "Bool to use when Consul is enabled"
  type        = bool
  default     = false
}

variable "prometheus_enabled" {
  description = "Bool to use when Prometheus is enabled"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "The name of the k8s cluster"
  type        = string
  default     = ""
}

variable "polkadot_client_url" {
  description = "URL to Polkadot client binary"
  type        = string
  default     = "https://github.com/w3f/polkadot/releases/download/v0.7.32/polkadot"
}

variable "polkadot_client_hash" {
  description = "SHA256 hash of Polkadot client binary"
  type        = string
  default     = "c34d63e5d80994b2123a3a0b7c5a81ce8dc0f257ee72064bf06654c2b93e31c9"
}

variable "node_exporter_url" {
  description = "URL to Node Exporter binary"
  type        = string
  default     = "https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz"
}

variable "node_exporter_hash" {
  description = "SHA256 hash of Node Exporter binary"
  type        = string
  default     = "b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424"
}

#####
# Load Balancer
#####
variable "use_lb" {
  description = "Bool to enable use of load balancer"
  type        = bool
  default     = true
}

variable "use_external_lb" {
  description = "Bool to switch between public (true) or private (false)"
  type        = bool
  default     = true
}

variable "region" {
  description = "The Azure region to deploy in"
  type        = string
  default     = "eastus"
}