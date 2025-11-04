# =============================================================================
# Resource Outputs
# =============================================================================

output "id" {
  value       = azurerm_public_ip_prefix.this.id
  description = "The public IP prefix resource ID"
}

output "name" {
  value       = azurerm_public_ip_prefix.this.name
  description = "The public IP prefix name"
}

output "ip_prefix" {
  value       = azurerm_public_ip_prefix.this.ip_prefix
  description = "The IP address prefix value that was allocated (e.g., 40.121.183.0/28)"
}

# =============================================================================
# Configuration Outputs
# =============================================================================

output "location" {
  value       = azurerm_public_ip_prefix.this.location
  description = "The Azure region where the public IP prefix is deployed"
}

output "resource_group_name" {
  value       = azurerm_public_ip_prefix.this.resource_group_name
  description = "The resource group name containing the public IP prefix"
}

output "prefix_length" {
  value       = azurerm_public_ip_prefix.this.prefix_length
  description = "The prefix length of the IP address block"
}

output "ip_version" {
  value       = azurerm_public_ip_prefix.this.ip_version
  description = "The IP version (IPv4 or IPv6)"
}

output "sku" {
  value       = azurerm_public_ip_prefix.this.sku
  description = "The SKU of the public IP prefix (Standard)"
}

output "availability_zones" {
  value       = azurerm_public_ip_prefix.this.zones
  description = "The availability zones where the public IP prefix is allocated"
}

# =============================================================================
# Tagging Outputs
# =============================================================================

output "tags" {
  value       = azurerm_public_ip_prefix.this.tags
  description = "The tags applied to the public IP prefix resource"
}

# =============================================================================
# Convenience Outputs
# =============================================================================

output "number_of_ip_addresses" {
  value       = pow(2, 32 - azurerm_public_ip_prefix.this.prefix_length)
  description = "The number of IP addresses allocated in this prefix block (calculated from prefix length)"
}
