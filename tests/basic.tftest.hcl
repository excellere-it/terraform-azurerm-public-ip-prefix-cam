# =============================================================================
# Basic Functionality Tests
# =============================================================================
#
# These tests validate core module functionality using plan-only commands.
# No Azure resources are created, ensuring fast and cost-free execution.
#

mock_provider "azurerm" {
  mock_resource "azurerm_public_ip_prefix" {
    defaults = {
      id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/publicIPPrefixes/ippre-test"
      ip_prefix = "40.121.183.0/28"
    }
  }
}

# Test: Default configuration with minimum required inputs
run "test_basic_creation" {
  command = plan

  variables {
    # Required terraform-namer inputs
    contact     = "test@example.com"
    environment = "dev"
    location    = "centralus"
    repository  = "terraform-azurerm-public-ip-prefix"
    workload    = "test"

    # Required resource configuration
    resource_group_name = "rg-test-cu-dev-kmi-0"
  }

  # Validate naming conventions
  assert {
    condition     = can(regex("^ippre-", output.name))
    error_message = "Public IP prefix name must start with 'ippre-' prefix"
  }

  # Validate tagging
  assert {
    condition     = output.tags != null
    error_message = "Resource tags must be present"
  }

  assert {
    condition     = contains(keys(output.tags), "Environment")
    error_message = "Tags must include 'Environment' from terraform-namer"
  }

  assert {
    condition     = output.tags["Environment"] == "dev"
    error_message = "Environment tag must match input variable"
  }

  # Validate default prefix length
  assert {
    condition     = output.prefix_length == 28
    error_message = "Default prefix length should be 28"
  }

  # Validate default IP version
  assert {
    condition     = output.ip_version == "IPv4"
    error_message = "Default IP version should be IPv4"
  }

  # Validate number of IP addresses calculation
  assert {
    condition     = output.number_of_ip_addresses == 16
    error_message = "Prefix length /28 should allocate 16 IP addresses"
  }
}

# Test: IPv6 configuration
run "test_ipv6_configuration" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"

    # IPv6 specific configuration
    ip_version    = "IPv6"
    prefix_length = 28
  }

  assert {
    condition     = output.ip_version == "IPv6"
    error_message = "IP version should be IPv6"
  }

  assert {
    condition     = output.ip_version == "IPv6"
    error_message = "Module must support IPv6 configuration"
  }
}

# Test: Availability zones configuration
run "test_availability_zones" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "prd"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "app"
    resource_group_name = "rg-app-cu-prd-kmi-0"

    # Zone-redundant configuration
    availability_zones = ["1", "2", "3"]
  }

  assert {
    condition     = length(output.availability_zones) == 3
    error_message = "Should configure 3 availability zones"
  }

  assert {
    condition     = output.tags["Environment"] == "prd"
    error_message = "Environment tag must be 'prd'"
  }
}

# Test: Different prefix lengths
run "test_prefix_length_29" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"

    prefix_length = 29
  }

  assert {
    condition     = output.prefix_length == 29
    error_message = "Prefix length should be 29"
  }

  assert {
    condition     = output.number_of_ip_addresses == 8
    error_message = "Prefix length /29 should allocate 8 IP addresses"
  }
}

run "test_prefix_length_30" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"

    prefix_length = 30
  }

  assert {
    condition     = output.prefix_length == 30
    error_message = "Prefix length should be 30"
  }

  assert {
    condition     = output.number_of_ip_addresses == 4
    error_message = "Prefix length /30 should allocate 4 IP addresses"
  }
}

run "test_prefix_length_31" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"

    prefix_length = 31
  }

  assert {
    condition     = output.prefix_length == 31
    error_message = "Prefix length should be 31"
  }

  assert {
    condition     = output.number_of_ip_addresses == 2
    error_message = "Prefix length /31 should allocate 2 IP addresses"
  }
}

# Test: Production environment configuration
run "test_production_config" {
  command = plan

  variables {
    contact             = "production@company.com"
    environment         = "prd"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "app"
    resource_group_name = "rg-app-cu-prd-kmi-0"

    prefix_length      = 28
    availability_zones = ["1", "2", "3"]
  }

  assert {
    condition     = output.tags["Environment"] == "prd"
    error_message = "Environment tag must be 'prd'"
  }

  assert {
    condition     = output.sku == "Standard"
    error_message = "SKU must be Standard"
  }
}

# Test: All outputs are present
run "test_all_outputs" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"
  }

  # Validate naming
  assert {
    condition     = can(regex("^ippre-", output.name))
    error_message = "Public IP prefix name must start with 'ippre-' prefix"
  }

  # Configuration outputs
  assert {
    condition = (
      output.location != null &&
      output.resource_group_name != null &&
      output.prefix_length != null &&
      output.ip_version != null &&
      output.sku != null
    )
    error_message = "Configuration outputs must be present"
  }

  # Convenience outputs
  assert {
    condition     = output.number_of_ip_addresses != null
    error_message = "Convenience outputs must be present"
  }
}
