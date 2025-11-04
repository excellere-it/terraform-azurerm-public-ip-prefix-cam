# =============================================================================
# Edge Case Tests
# =============================================================================
#
# These tests validate edge cases and complex scenarios that combine
# multiple features or test boundary conditions.
#

mock_provider "azurerm" {
  mock_resource "azurerm_public_ip_prefix" {
    defaults = {
      id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/publicIPPrefixes/ippre-test"
      ip_prefix = "40.121.183.0/28"
    }
  }
}

# Test: Single availability zone
run "test_single_availability_zone" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "app"
    resource_group_name = "rg-app-cu-dev-kmi-0"

    availability_zones = ["1"]
  }

  assert {
    condition     = length(output.availability_zones) == 1
    error_message = "Should configure exactly 1 availability zone"
  }

  assert {
    condition     = contains(output.availability_zones, "1")
    error_message = "Zone 1 should be in the availability zones list"
  }
}

# Test: Two availability zones
run "test_two_availability_zones" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "prd"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "app"
    resource_group_name = "rg-app-cu-prd-kmi-0"

    availability_zones = ["1", "2"]
  }

  assert {
    condition     = length(output.availability_zones) == 2
    error_message = "Should configure exactly 2 availability zones"
  }

  assert {
    condition = alltrue([
      contains(output.availability_zones, "1"),
      contains(output.availability_zones, "2")
    ])
    error_message = "Zones 1 and 2 should be in the availability zones list"
  }
}

# Test: IPv6 with availability zones
run "test_ipv6_with_availability_zones" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "prd"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "app"
    resource_group_name = "rg-app-cu-prd-kmi-0"

    ip_version         = "IPv6"
    prefix_length      = 28
    availability_zones = ["1", "2", "3"]
  }

  assert {
    condition     = output.ip_version == "IPv6"
    error_message = "IP version should be IPv6"
  }

  assert {
    condition     = length(output.availability_zones) == 3
    error_message = "Should configure 3 availability zones"
  }

  assert {
    condition     = output.prefix_length == 28
    error_message = "Prefix length should be 28"
  }
}

# Test: IPv6 with different prefix lengths
run "test_ipv6_prefix_length_29" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"

    ip_version    = "IPv6"
    prefix_length = 29
  }

  assert {
    condition     = output.ip_version == "IPv6"
    error_message = "IP version should be IPv6"
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

run "test_ipv6_prefix_length_30" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"

    ip_version    = "IPv6"
    prefix_length = 30
  }

  assert {
    condition     = output.ip_version == "IPv6"
    error_message = "IP version should be IPv6"
  }

  assert {
    condition     = output.prefix_length == 30
    error_message = "Prefix length should be 30"
  }
}

run "test_ipv6_prefix_length_31" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "test"
    resource_group_name = "rg-test-cu-dev-kmi-0"

    ip_version    = "IPv6"
    prefix_length = 31
  }

  assert {
    condition     = output.ip_version == "IPv6"
    error_message = "IP version should be IPv6"
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

# Test: Maximum workload length (20 characters)
run "test_max_workload_length" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "12345678901234567890" # Exactly 20 chars
    resource_group_name = "rg-test-cu-dev-kmi-0"
  }

  assert {
    condition     = output.name != null
    error_message = "Module should work with maximum workload length (20 chars)"
  }

  assert {
    condition     = can(regex("12345678901234567890", output.name))
    error_message = "Resource name should include the workload value"
  }

  assert {
    condition     = output.tags != null
    error_message = "Tags should be present"
  }
}

# Test: Regional (non-zonal) deployment
run "test_regional_non_zonal" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "app"
    resource_group_name = "rg-app-cu-dev-kmi-0"

    availability_zones = [] # Explicitly empty
  }

  assert {
    condition     = length(output.availability_zones) == 0
    error_message = "Regional deployment should have no availability zones"
  }

  assert {
    condition     = output.name != null
    error_message = "Module should work without availability zones"
  }
}

# Test: All terraform-namer tags present
run "test_all_terraform_namer_tags" {
  command = plan

  variables {
    contact             = "compliance@company.com"
    environment         = "prd"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "critical"
    resource_group_name = "rg-critical-cu-prd-kmi-0"
  }

  assert {
    condition = alltrue([
      contains(keys(output.tags), "Company"),
      contains(keys(output.tags), "Contact"),
      contains(keys(output.tags), "Environment"),
      contains(keys(output.tags), "Repository"),
      contains(keys(output.tags), "Source"),
      contains(keys(output.tags), "Workspace")
    ])
    error_message = "All terraform-namer tags must be present"
  }

  assert {
    condition     = output.tags["Contact"] == "compliance@company.com"
    error_message = "Contact tag should match input variable"
  }

  assert {
    condition     = output.tags["Environment"] == "prd"
    error_message = "Environment tag should match input variable"
  }

  assert {
    condition     = output.tags["Repository"] == "terraform-azurerm-public-ip-prefix"
    error_message = "Repository tag should match input variable"
  }
}

# Test: Smallest prefix (/31 with 2 IPs) with IPv6
run "test_smallest_ipv6_prefix" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "minimal"
    resource_group_name = "rg-minimal-cu-dev-kmi-0"

    ip_version    = "IPv6"
    prefix_length = 31
  }

  assert {
    condition     = output.ip_version == "IPv6"
    error_message = "Should support IPv6 with smallest prefix"
  }

  assert {
    condition     = output.prefix_length == 31
    error_message = "Should support /31 prefix with IPv6"
  }

  assert {
    condition     = output.number_of_ip_addresses == 2
    error_message = "Smallest prefix should allocate 2 IPs"
  }
}

# Test: Largest prefix (/28 with 16 IPs) with all zones
run "test_largest_prefix_all_zones" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "prd"
    location            = "centralus"
    repository          = "terraform-azurerm-public-ip-prefix"
    workload            = "large"
    resource_group_name = "rg-large-cu-prd-kmi-0"

    prefix_length      = 28
    availability_zones = ["1", "2", "3"]
  }

  assert {
    condition     = output.prefix_length == 28
    error_message = "Should support /28 prefix"
  }

  assert {
    condition     = output.number_of_ip_addresses == 16
    error_message = "Largest prefix should allocate 16 IPs"
  }

  assert {
    condition     = length(output.availability_zones) == 3
    error_message = "Should support all 3 availability zones"
  }

  assert {
    condition     = output.sku == "Standard"
    error_message = "Standard SKU required for zone redundancy"
  }
}
