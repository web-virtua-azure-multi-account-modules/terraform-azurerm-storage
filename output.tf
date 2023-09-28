output "storage_account" {
  description = "Storage account"
  value       = azurerm_storage_account.create_storage_account
}

output "storage_account_id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.create_storage_account.id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.create_storage_account.name
}

output "storage_account_identity" {
  description = "Storage account identity block"
  value       = azurerm_storage_account.create_storage_account.identity
}

output "storage_account_network_rules" {
  description = "Network rules of the associated storage account"
  value       = azurerm_storage_account.create_storage_account.network_rules
}

output "threat_protection" {
  description = "Advanced threat protection"
  value       = try(azurerm_advanced_threat_protection.create_threat_protection, null)
}

output "storage_containers" {
  description = "Storage containers"
  value       = try(azurerm_storage_container.storage_container, null)
}

output "storage_containers_ids" {
  description = "Storage containers IDs"
  value       = try(azurerm_storage_container.storage_container[*].id, null)
}
