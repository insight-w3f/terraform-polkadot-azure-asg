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

########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = ""
}

variable "zone" {
  description = "The Azure zone to deploy in"
  type        = string
  default     = "eastus"
}

#####
# instance
#####
variable "public_key_path" {
  description = "The path to the public ssh key"
  type        = string
  default     = ""
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

variable "num_instances" {
  description = "Number of instances for ASG"
  type        = number
  default     = 1
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

variable "security_group_id" {
  description = "The id of the security group to run in"
  type        = string
}

variable "lb_backend_pool_id" {
  description = "The ID of the load balancer backend IP pool"
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

variable "polkadot_chain" {
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
  default     = "wss://mi.private.telemetry.backend/"
}

variable "logging_filter" {
  description = "String for polkadot logging filter"
  type        = string
  default     = "sync=trace,afg=trace,babe=debug"
}

variable "relay_node_ip" {
  description = "Internal IP of Polkadot relay node"
  type        = string
}

variable "relay_node_p2p_address" {
  description = "P2P address of Polkadot relay node"
  type        = string
}