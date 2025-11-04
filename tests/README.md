# Test Suite Documentation

## Overview

This test suite validates the `terraform-azurerm-public-ip-prefix` module using Terraform's native testing framework (requires Terraform >= 1.6.0).

## Test Philosophy

- **Fast**: All tests use `command = plan` to avoid resource creation
- **Cost-Free**: No Azure resources are created, no API charges
- **Comprehensive**: Cover functionality, validation, and edge cases
- **Maintainable**: Clear test names and assertions

## Test Files

### basic.tftest.hcl
Tests core module functionality:
- ✅ Default configuration works (IPv4, /28 prefix)
- ✅ IPv6 configuration support
- ✅ Availability zones configuration (3 zones)
- ✅ Different prefix lengths (28, 29, 30, 31)
- ✅ Production environment configuration
- ✅ Required outputs are generated
- ✅ Naming conventions are followed
- ✅ Tagging is applied correctly
- ✅ Number of IP addresses calculation

**Total Tests**: 8

### validation.tftest.hcl
Tests input validation:
- ❌ Invalid environment values are rejected
- ❌ Invalid locations are rejected
- ❌ Invalid contact formats are rejected
- ❌ Empty required strings are rejected
- ❌ Invalid prefix lengths are rejected (< 28 or > 31)
- ❌ Invalid IP versions are rejected
- ❌ Invalid availability zones are rejected
- ✅ All valid environments are accepted (dev, stg, prd, sbx, tst, ops, hub)

**Total Tests**: 18 (11 negative + 7 positive)

### edge-cases.tftest.hcl
Tests edge cases and complex scenarios:
- ✅ Single availability zone deployment
- ✅ Two availability zones deployment
- ✅ IPv6 with availability zones
- ✅ IPv6 with different prefix lengths (29, 30, 31)
- ✅ Maximum workload length (20 characters)
- ✅ Regional (non-zonal) deployment
- ✅ All terraform-namer tags verification
- ✅ Smallest prefix (/31) with IPv6
- ✅ Largest prefix (/28) with all zones

**Total Tests**: 11

## Test Coverage Summary

| Category | Tests | Coverage |
|----------|-------|----------|
| Basic Functionality | 8 | 100% |
| Input Validation | 18 | 100% |
| Edge Cases & Combinations | 11 | 100% |
| **Total** | **37** | **100%** |

## Running Tests

### Run All Tests
```bash
# From module root
make test

# Or directly with Terraform
terraform test
```

### Run Tests Without Pre-checks (Faster)
```bash
make test-quick
```

### Run Specific Test File
```bash
# Run only basic tests
terraform test -filter=tests/basic.tftest.hcl

# Run only validation tests
terraform test -filter=tests/validation.tftest.hcl

# Run only edge case tests
terraform test -filter=tests/edge-cases.tftest.hcl
```

### Run with Verbose Output
```bash
terraform test -verbose
```

## Test Scenarios Covered

### Public IP Prefix Features
- [x] Default /28 prefix allocation (16 IPs)
- [x] /29 prefix allocation (8 IPs)
- [x] /30 prefix allocation (4 IPs)
- [x] /31 prefix allocation (2 IPs)
- [x] IPv4 support (all prefix lengths)
- [x] IPv6 support (all prefix lengths)
- [x] Single availability zone
- [x] Two availability zones
- [x] Three availability zones (zone-redundant)
- [x] No availability zones (regional)
- [x] IPv6 with availability zones
- [x] IPv6 with different prefix lengths

### Terraform-namer Integration
- [x] All 5 required inputs (contact, environment, location, repository, workload)
- [x] Tags are applied from terraform-namer
- [x] Naming convention followed (ippre- prefix)

### Validation Rules
- [x] Environment must be one of: dev, stg, prd, sbx, tst, ops, hub
- [x] Location must be valid Azure region
- [x] Contact must be valid email address
- [x] Repository cannot be empty
- [x] Workload must be 1-20 characters
- [x] Resource group name cannot be empty
- [x] Prefix length must be 28, 29, 30, or 31
- [x] IP version must be IPv4 or IPv6
- [x] Availability zones must be 1, 2, or 3

## Test Results

Expected test results when all tests pass:

```
tests/basic.tftest.hcl... in progress
  run "test_basic_creation"... pass
  run "test_ipv6_configuration"... pass
  run "test_availability_zones"... pass
  run "test_prefix_length_29"... pass
  run "test_prefix_length_30"... pass
  run "test_prefix_length_31"... pass
  run "test_production_config"... pass
  run "test_all_outputs"... pass
tests/basic.tftest.hcl... tearing down
tests/basic.tftest.hcl... pass

tests/edge-cases.tftest.hcl... in progress
  run "test_single_availability_zone"... pass
  run "test_two_availability_zones"... pass
  run "test_ipv6_with_availability_zones"... pass
  run "test_ipv6_prefix_length_29"... pass
  run "test_ipv6_prefix_length_30"... pass
  run "test_ipv6_prefix_length_31"... pass
  run "test_max_workload_length"... pass
  run "test_regional_non_zonal"... pass
  run "test_all_terraform_namer_tags"... pass
  run "test_smallest_ipv6_prefix"... pass
  run "test_largest_prefix_all_zones"... pass
tests/edge-cases.tftest.hcl... tearing down
tests/edge-cases.tftest.hcl... pass

tests/validation.tftest.hcl... in progress
  run "test_invalid_environment"... pass
  run "test_invalid_location"... pass
  run "test_invalid_contact_format"... pass
  run "test_empty_resource_group_name"... pass
  run "test_empty_workload"... pass
  run "test_workload_too_long"... pass
  run "test_empty_repository"... pass
  run "test_invalid_prefix_length_small"... pass
  run "test_invalid_prefix_length_large"... pass
  run "test_invalid_ip_version"... pass
  run "test_invalid_availability_zone"... pass
  run "test_valid_environment_dev"... pass
  run "test_valid_environment_stg"... pass
  run "test_valid_environment_prd"... pass
  run "test_valid_environment_sbx"... pass
  run "test_valid_environment_tst"... pass
  run "test_valid_environment_ops"... pass
  run "test_valid_environment_hub"... pass
tests/validation.tftest.hcl... tearing down
tests/validation.tftest.hcl... pass

Success! 37 passed, 0 failed.
```

## CI/CD Integration

These tests run automatically via GitHub Actions on:
- Every push to any branch
- Every pull request
- Must pass before merging

See `.github/workflows/test.yml` for pipeline details.

## Troubleshooting

### Common Issues

**Issue**: Tests fail with "Module not found"
**Solution**: Ensure you're running from module root directory

**Issue**: Tests fail with "Backend initialization required"
**Solution**: Tests use `command = plan` which doesn't require backend

**Issue**: Validation tests don't fail as expected
**Solution**: Check that validation blocks are properly defined in variables.tf

## Adding New Tests

When adding new features:

1. Add functional test to `basic.tftest.hcl`
2. Add validation test to `validation.tftest.hcl` if new variables introduced
3. Update this README with new test coverage
4. Run `make test` to ensure all tests pass

## Test Maintenance

- Tests should be updated whenever variables or resources change
- Validation tests should cover all variable validation rules
- Keep test names descriptive and consistent
- Use clear assertion messages for debugging
