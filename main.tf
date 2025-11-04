# =============================================================================
# Module: Azure Public IP Prefix
# =============================================================================
#
# Purpose:
#   This module creates and manages Azure Public IP Prefix resources for
#   reserving contiguous blocks of public IP addresses.
#
# Features:
#   - Configurable prefix length (/28, /29, /30, /31)
#   - Optional availability zones for high availability
#   - Optional DDoS protection plan association
#   - IPv4 and IPv6 support
#   - Consistent naming and tagging via terraform-namer
#   - Comprehensive input validation
#   - Full test coverage
#
# Resources Created:
#   - azurerm_public_ip_prefix
#
# Dependencies:
#   - terraform-terraform-namer (required)
#
# Usage:
#   module "public_ip_prefix" {
#     source = "path/to/terraform-azurerm-public-ip-prefix"
#
#     contact     = "owner@company.com"
#     environment = "dev"
#     location    = "centralus"
#     repository  = "terraform-azurerm-public-ip-prefix"
#     workload    = "app"
#
#     resource_group_name = "rg-app-cu-dev-kmi-0"
#     prefix_length       = 28
#   }
#
# Public IP Prefix Sizes:
#   - /28 = 16 IP addresses
#   - /29 = 8 IP addresses
#   - /30 = 4 IP addresses
#   - /31 = 2 IP addresses
#
# Security Considerations:
#   - DDoS protection is optional but recommended for production
#   - Proper tagging ensures governance and cost tracking
#   - Availability zones provide high availability
#
# =============================================================================

# =============================================================================
# Section: Naming and Tagging
# =============================================================================

module "naming" {
  source  = "app.terraform.io/cardi/namer-cam/terraform"
  version = "0.0.1"

  contact     = var.contact
  environment = var.environment
  location    = var.location
  repository  = var.repository
  workload    = var.workload
}

# =============================================================================
# Section: Main Resources
# =============================================================================

resource "azurerm_public_ip_prefix" "this" {
  name                = "ippre-${module.naming.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Prefix configuration
  prefix_length = var.prefix_length
  ip_version    = var.ip_version
  sku           = "Standard"

  # High availability configuration
  zones = var.availability_zones

  tags = module.naming.tags
}

# =============================================================================
# Section: Diagnostics Integration (Optional)
# =============================================================================
# Enable diagnostic settings for Public IP Prefix DDoS and usage monitoring

module "diagnostics" {
  count   = var.diagnostics.enabled ? 1 : 0
  source  = "app.terraform.io/cardi/diagnostics-cam/azurerm"
  version = "0.0.1"

  log_analytics_workspace_id = var.diagnostics.log_analytics_workspace_id

  monitored_services = {
    ip_prefix = {
      id      = azurerm_public_ip_prefix.this.id
      table   = var.diagnostics.destination_type
      include = [] # Enable all available diagnostic categories
    }
  }
}
