# =============================================================================
# Required Variables
# =============================================================================

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the public IP prefix"

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty"
  }
}

# =============================================================================
# Public IP Prefix Configuration
# =============================================================================

variable "prefix_length" {
  type        = number
  description = "The prefix length of the IP address block. Valid values are 28, 29, 30, or 31 (28=/16 IPs, 29=/8 IPs, 30=/4 IPs, 31=/2 IPs)"
  default     = 28

  validation {
    condition     = contains([28, 29, 30, 31], var.prefix_length)
    error_message = "Prefix length must be one of: 28 (16 IPs), 29 (8 IPs), 30 (4 IPs), or 31 (2 IPs)"
  }
}

variable "ip_version" {
  type        = string
  description = "The IP version to use. Valid values are IPv4 or IPv6"
  default     = "IPv4"

  validation {
    condition     = contains(["IPv4", "IPv6"], var.ip_version)
    error_message = "IP version must be either IPv4 or IPv6"
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones where the public IP prefix should be allocated. Valid values are 1, 2, and/or 3. Leave empty for non-zonal"
  default     = []

  validation {
    condition = alltrue([
      for zone in var.availability_zones : contains(["1", "2", "3"], zone)
    ])
    error_message = "Availability zones must be a list containing only 1, 2, and/or 3"
  }
}

# =============================================================================
# Naming Variables (terraform-namer)
# =============================================================================

variable "contact" {
  type        = string
  description = "Contact email for resource ownership and notifications"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.contact))
    error_message = "Contact must be a valid email address"
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, stg, prd, sbx, tst, ops, hub)"

  validation {
    condition     = contains(["dev", "stg", "prd", "sbx", "tst", "ops", "hub"], var.environment)
    error_message = "Environment must be one of: dev, stg, prd, sbx, tst, ops, hub"
  }
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"

  validation {
    condition = contains([
      "centralus", "eastus", "eastus2", "westus", "westus2", "westus3",
      "northcentralus", "southcentralus", "westcentralus",
      "canadacentral", "canadaeast",
      "brazilsouth",
      "northeurope", "westeurope",
      "uksouth", "ukwest",
      "francecentral", "francesouth",
      "germanywestcentral",
      "switzerlandnorth",
      "norwayeast",
      "eastasia", "southeastasia",
      "japaneast", "japanwest",
      "australiaeast", "australiasoutheast",
      "centralindia", "southindia", "westindia"
    ], var.location)
    error_message = "Location must be a valid Azure region"
  }
}

variable "repository" {
  type        = string
  description = "Source repository name for tracking and documentation"

  validation {
    condition     = length(var.repository) > 0
    error_message = "Repository name cannot be empty"
  }
}

variable "workload" {
  type        = string
  description = "Workload or application name for resource identification"

  validation {
    condition     = length(var.workload) > 0 && length(var.workload) <= 20
    error_message = "Workload name must be 1-20 characters"
  }
}

variable "diagnostics" {
  description = "Diagnostic settings configuration for Public IP Prefix"
  type = object({
    enabled                    = bool
    log_analytics_workspace_id = string
    destination_type          = optional(string, "Dedicated")
  })
  default = {
    enabled                    = false
    log_analytics_workspace_id = null
    destination_type          = "Dedicated"
  }
}
