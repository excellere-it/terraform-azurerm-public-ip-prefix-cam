# GitHub Actions Workflows

This directory contains CI/CD workflows for the terraform-azurerm-public-ip-prefix module.

## Workflows

### test.yml
**Purpose**: Comprehensive testing pipeline
**Trigger**: Push to any branch, Pull Requests

**Jobs**:
1. **terraform-format** - Validates Terraform formatting
2. **terraform-validate** - Validates Terraform configuration
3. **security-scan** - Runs Checkov security analysis (soft fail)
4. **lint** - Runs TFLint code quality checks
5. **test-examples** - Matrix test all examples (init, validate, plan)
6. **test-summary** - Aggregates results, fails if required tests fail
7. **comment-pr** - Posts results to PR with status icons

**Estimated Runtime**: 15-20 minutes

### release-module.yml
**Purpose**: Automated release creation
**Trigger**: Version tags (e.g., v0.1.0, 0.0.5)

**Actions**:
- Creates GitHub release
- Generates release notes from CHANGELOG.md
- Tags repository

## Required Secrets

None - workflows use `GITHUB_TOKEN` automatically provided by GitHub Actions.

## Status Badges

Add to README.md:
```markdown
[![Tests](https://github.com/org/terraform-azurerm-public-ip-prefix/actions/workflows/test.yml/badge.svg)](https://github.com/org/terraform-azurerm-public-ip-prefix/actions/workflows/test.yml)
```
