module "public_ip_prefix" {
  source = "../.."

  # Required: terraform-namer inputs
  contact     = "example@company.com"
  environment = "dev"
  location    = "centralus"
  repository  = "terraform-azurerm-public-ip-prefix"
  workload    = "example"

  # Required: resource configuration
  resource_group_name = "rg-example-cu-dev-kmi-0"

  # Optional: public IP prefix configuration
  prefix_length      = 28 # 16 IP addresses
  ip_version         = "IPv4"
  availability_zones = ["1", "2", "3"] # Zone-redundant for high availability
}

# Example outputs to demonstrate usage
output "public_ip_prefix_id" {
  value       = module.public_ip_prefix.id
  description = "The public IP prefix resource ID"
}

output "ip_prefix" {
  value       = module.public_ip_prefix.ip_prefix
  description = "The allocated IP address prefix (e.g., 40.121.183.0/28)"
}

output "number_of_ips" {
  value       = module.public_ip_prefix.number_of_ip_addresses
  description = "Number of IP addresses in the prefix block"
}
