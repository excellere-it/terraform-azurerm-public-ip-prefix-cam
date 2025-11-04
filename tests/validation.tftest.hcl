# =============================================================================
# Input Validation Tests
# =============================================================================
#
# These tests validate that input variables are properly constrained and
# that invalid inputs trigger appropriate validation errors.
#

mock_provider "azurerm" {
  mock_resource "azurerm_public_ip_prefix" {
    defaults = {
      id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/publicIPPrefixes/ippre-test"
      ip_prefix = "40.121.183.0/28"
    }
  }
}

# Test: Invalid environment value
run "test_invalid_environment" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "invalid"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  expect_failures = [
    var.environment,
  ]
}

# Test: Invalid location value
run "test_invalid_location" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "invalid-region"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  expect_failures = [
    var.location,
  ]
}

# Test: Invalid contact format
run "test_invalid_contact_format" {
  command = plan

  variables {
    contact             = "not-an-email"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  expect_failures = [
    var.contact,
  ]
}

# Test: Empty required string (resource_group_name)
run "test_empty_resource_group_name" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = ""
  }

  expect_failures = [
    var.resource_group_name,
  ]
}

# Test: Empty workload
run "test_empty_workload" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = ""
    resource_group_name = "rg-test"
  }

  expect_failures = [
    var.workload,
  ]
}

# Test: Workload too long
run "test_workload_too_long" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "this-workload-name-is-way-too-long-for-validation"
    resource_group_name = "rg-test"
  }

  expect_failures = [
    var.workload,
  ]
}

# Test: Empty repository
run "test_empty_repository" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = ""
    workload            = "test"
    resource_group_name = "rg-test"
  }

  expect_failures = [
    var.repository,
  ]
}

# Test: Invalid prefix length (too small)
run "test_invalid_prefix_length_small" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"

    prefix_length = 27 # Too small
  }

  expect_failures = [
    var.prefix_length,
  ]
}

# Test: Invalid prefix length (too large)
run "test_invalid_prefix_length_large" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"

    prefix_length = 32 # Too large
  }

  expect_failures = [
    var.prefix_length,
  ]
}

# Test: Invalid IP version
run "test_invalid_ip_version" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"

    ip_version = "IPv5" # Invalid
  }

  expect_failures = [
    var.ip_version,
  ]
}

# Test: Invalid availability zone
run "test_invalid_availability_zone" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"

    availability_zones = ["1", "4"] # 4 is invalid
  }

  expect_failures = [
    var.availability_zones,
  ]
}

# Test: All valid environments
run "test_valid_environment_dev" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "dev"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  assert {
    condition     = output.tags["Environment"] == "dev"
    error_message = "Environment dev should be valid"
  }
}

run "test_valid_environment_stg" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "stg"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  assert {
    condition     = output.tags["Environment"] == "stg"
    error_message = "Environment stg should be valid"
  }
}

run "test_valid_environment_prd" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "prd"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  assert {
    condition     = output.tags["Environment"] == "prd"
    error_message = "Environment prd should be valid"
  }
}

run "test_valid_environment_sbx" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "sbx"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  assert {
    condition     = output.tags["Environment"] == "sbx"
    error_message = "Environment sbx should be valid"
  }
}

run "test_valid_environment_tst" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "tst"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  assert {
    condition     = output.tags["Environment"] == "tst"
    error_message = "Environment tst should be valid"
  }
}

run "test_valid_environment_ops" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "ops"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  assert {
    condition     = output.tags["Environment"] == "ops"
    error_message = "Environment ops should be valid"
  }
}

run "test_valid_environment_hub" {
  command = plan

  variables {
    contact             = "test@example.com"
    environment         = "hub"
    location            = "centralus"
    repository          = "test-repo"
    workload            = "test"
    resource_group_name = "rg-test"
  }

  assert {
    condition     = output.tags["Environment"] == "hub"
    error_message = "Environment hub should be valid"
  }
}
