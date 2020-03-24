output "scale_set_name" {
  value = join("", azurerm_linux_virtual_machine_scale_set.sentry.*.name)
}


output "cmd" {
  value = module.packer.packer_command
}