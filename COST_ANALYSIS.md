# Cost Analysis: terraform-azurerm-public-ip-prefix

**Module**: terraform-azurerm-public-ip-prefix
**Analysis Date**: 2025-10-28
**Pricing Currency**: USD
**Pricing Source**: Azure Pricing Calculator (October 2025)

---

## Executive Summary

Azure Public IP Prefix reservations provide contiguous blocks of public IP addresses with **predictable monthly costs** based on prefix size. This module creates Standard SKU IP prefixes with optional zone redundancy.

### Cost Overview

| Prefix Size | IP Addresses | Monthly Cost (US East) | Annual Cost |
|-------------|--------------|------------------------|-------------|
| /28 | 16 IPs | ~$19.20 | ~$230.40 |
| /29 | 8 IPs | ~$9.60 | ~$115.20 |
| /30 | 4 IPs | ~$4.80 | ~$57.60 |
| /31 | 2 IPs | ~$2.40 | ~$28.80 |

**Key Findings**:
- ✅ **Fixed Monthly Cost**: Predictable billing regardless of actual IP usage
- ✅ **No Bandwidth Charges**: Public IP Prefix itself has no data transfer costs
- ✅ **Zone Redundancy Included**: Standard SKU supports zones at no extra charge
- ⚠️ **Reservation Required**: You pay for the entire prefix block even if IPs are unused
- 💰 **Cost Savings**: Can be cheaper than multiple individual Public IPs for large deployments

---

## Detailed Pricing Breakdown

### 1. Base Pricing Structure

Azure Public IP Prefix pricing is based on **two factors**:
1. **IP Address Reservation Cost**: Fixed cost per IP address per hour
2. **Prefix Size**: Number of IP addresses in the block

**Standard SKU Pricing** (US East Region):
- Cost per IP address: **$0.005/hour** (~$3.65/month per IP)
- Billing model: Per-hour, per-IP address in prefix
- Minimum commitment: Entire prefix block

### 2. Pricing by Prefix Length

#### /28 Prefix (16 IP Addresses)

```
Calculation:
16 IPs × $0.005/hour × 730 hours/month = $58.40/month
```

**Use Cases**:
- Medium-sized deployments (10-15 resources)
- Microservices architectures with multiple public endpoints
- Load balancer pools with failover IPs

**Cost Comparison**:
- Individual Public IPs: 16 × $3.65/month = **$58.40/month** (same cost)
- Benefit: Contiguous IP block for routing efficiency

#### /29 Prefix (8 IP Addresses)

```
Calculation:
8 IPs × $0.005/hour × 730 hours/month = $29.20/month
```

**Use Cases**:
- Small application clusters
- Development/staging environments
- Dual-stack (IPv4 + IPv6) deployments

**Cost Comparison**:
- Individual Public IPs: 8 × $3.65/month = **$29.20/month** (same cost)

#### /30 Prefix (4 IP Addresses)

```
Calculation:
4 IPs × $0.005/hour × 730 hours/month = $14.60/month
```

**Use Cases**:
- Small production deployments
- High availability pairs (primary + secondary)
- Testing IP prefix functionality

**Cost Comparison**:
- Individual Public IPs: 4 × $3.65/month = **$14.60/month** (same cost)

#### /31 Prefix (2 IP Addresses)

```
Calculation:
2 IPs × $0.005/hour × 730 hours/month = $7.30/month
```

**Use Cases**:
- Minimum viable allocation
- Point-to-point connections
- Cost-conscious testing

**Cost Comparison**:
- Individual Public IPs: 2 × $3.65/month = **$7.30/month** (same cost)

---

## Regional Pricing Variations

### US Regions (East, East 2, Central, West, West 2)

| Prefix | Monthly Cost | Annual Cost |
|--------|--------------|-------------|
| /28 (16 IPs) | $58.40 | $700.80 |
| /29 (8 IPs) | $29.20 | $350.40 |
| /30 (4 IPs) | $14.60 | $175.20 |
| /31 (2 IPs) | $7.30 | $87.60 |

### Europe Regions (North, West, UK South)

| Prefix | Monthly Cost | Annual Cost |
|--------|--------------|-------------|
| /28 (16 IPs) | $64.24 | $770.88 |
| /29 (8 IPs) | $32.12 | $385.44 |
| /30 (4 IPs) | $16.06 | $192.72 |
| /31 (2 IPs) | $8.03 | $96.36 |

**Europe Premium**: ~10% higher than US regions

### Asia Pacific Regions (Southeast Asia, East Asia)

| Prefix | Monthly Cost | Annual Cost |
|--------|--------------|-------------|
| /28 (16 IPs) | $70.08 | $840.96 |
| /29 (8 IPs) | $35.04 | $420.48 |
| /30 (4 IPs) | $17.52 | $210.24 |
| /31 (2 IPs) | $8.76 | $105.12 |

**Asia Premium**: ~20% higher than US regions

---

## IPv4 vs IPv6 Pricing

### IPv4 Public IP Prefix

**Current Pricing** (as shown above):
- Standard rate: $0.005/hour per IP
- Available prefix lengths: /28, /29, /30, /31

### IPv6 Public IP Prefix

**Pricing Structure**:
- **FREE**: IPv6 addresses are provided at no additional cost
- IPv6 prefixes: /124, /127 (equivalent to /28, /31 in IPv4)
- No hourly charges for IPv6 reservation

**Cost Savings with IPv6**:
```
/28 IPv4 Prefix: $58.40/month
/124 IPv6 Prefix: $0.00/month
Annual Savings: $700.80/year per prefix
```

**Recommendation**: For greenfield deployments or dual-stack scenarios, leverage IPv6 prefixes to reduce costs while maintaining IPv4 for legacy compatibility.

---

## Availability Zone Cost Implications

### Zone Redundancy (Standard SKU)

**Good News**: Availability zones are **included at no extra charge** with Standard SKU Public IP Prefix.

**Configurations Supported**:
- Single zone: `availability_zones = ["1"]`
- Dual zone: `availability_zones = ["1", "2"]`
- Zone-redundant: `availability_zones = ["1", "2", "3"]`
- Regional (no zones): `availability_zones = []`

**Cost Comparison**:

| Configuration | /28 Prefix Monthly Cost |
|---------------|-------------------------|
| Regional (no zones) | $58.40 |
| Single zone (1) | $58.40 |
| Dual zone (1, 2) | $58.40 |
| Zone-redundant (1, 2, 3) | $58.40 |

**Recommendation**: Always use zone-redundant configuration (`["1", "2", "3"]`) for production workloads at no additional cost to maximize availability.

---

## Cost Optimization Strategies

### 1. Right-Size Your Prefix

**Strategy**: Choose the smallest prefix that meets your current + near-term needs.

**Example**:
- Current need: 5 public IPs
- Growth projection: 2 additional IPs within 6 months
- **Recommended**: /29 (8 IPs) instead of /28 (16 IPs)
- **Savings**: $29.20/month vs $58.40/month = **$350.40/year**

### 2. Consolidate Individual IPs

**Strategy**: If you have multiple standalone Public IPs, consolidate into a prefix.

**Before**:
```
10 individual Public IPs × $3.65/month = $36.50/month
```

**After**:
```
/28 Public IP Prefix (16 IPs) = $58.40/month
Usable IPs: 16 (6 spare for growth)
Cost increase: $21.90/month
Benefit: Contiguous block, 60% spare capacity
```

**When to consolidate**: If you need 8+ IPs and expect growth

### 3. Leverage IPv6 Where Possible

**Strategy**: Use IPv6 prefixes for internal services, APIs, or modern applications.

**Hybrid Approach**:
```
/30 IPv4 Prefix (4 IPs): $14.60/month  ← External-facing services
/124 IPv6 Prefix: $0.00/month          ← Internal APIs, microservices
Total: $14.60/month vs $58.40/month all IPv4
Annual Savings: $525.60/year
```

### 4. Review and Cleanup Unused IPs

**Strategy**: Regularly audit IP usage within your prefix.

**Monitoring**:
- Use Azure Monitor to track IP assignments
- Set alerts for utilization < 50% for 30+ days
- Consider downsizing prefix if consistently underutilized

**Example**:
- /28 prefix (16 IPs) with 4 IPs used for 6 months
- Downsize to /30 (4 IPs)
- Savings: $58.40 - $14.60 = **$43.80/month** (~$525/year)

### 5. Environment-Specific Sizing

**Strategy**: Use different prefix sizes for different environments.

**Recommended Allocation**:
```
Production:   /28 (16 IPs) - $58.40/month   ← High availability, growth room
Staging:      /30 (4 IPs)  - $14.60/month   ← Mirror production topology
Development:  /31 (2 IPs)  - $7.30/month    ← Minimal footprint
```

**Total**: $80.30/month vs 3 × /28 = $175.20/month
**Savings**: **$94.90/month** (~$1,139/year)

### 6. Reserve in Primary Region Only

**Strategy**: Avoid multi-region IP prefix duplication unless required for geo-redundancy.

**Cost Impact**:
```
Single region (/28):      $58.40/month
Multi-region (3 × /28):   $175.20/month
```

**When multi-region makes sense**:
- Active-active global deployments
- Regulatory data residency requirements
- Sub-50ms latency SLAs

---

## Budget Planning and Forecasting

### Monthly Cost Scenarios

#### Small Deployment (Development Team)

**Configuration**:
- 1 × /30 prefix (4 IPs)
- Region: US Central
- Environment: Development

**Monthly Cost**: $14.60
**Annual Cost**: $175.20

#### Medium Deployment (Production Application)

**Configuration**:
- 1 × /28 prefix (16 IPs)
- 1 × /30 prefix (4 IPs) for staging
- Region: US East
- Environment: Production + Staging

**Monthly Cost**: $58.40 + $14.60 = **$73.00**
**Annual Cost**: $876.00

#### Large Deployment (Multi-Environment Enterprise)

**Configuration**:
- 2 × /28 prefix (16 IPs each) - Production (primary + DR)
- 1 × /29 prefix (8 IPs) - Staging
- 1 × /30 prefix (4 IPs) - Development
- Region: US East + US West (DR)

**Monthly Cost**:
```
Production (US East):  $58.40
Production (US West):  $58.40
Staging:               $29.20
Development:           $14.60
Total:                 $160.60/month
```

**Annual Cost**: $1,927.20

### Cost Projection Formula

```
Monthly Cost = (2^(32 - prefix_length)) × $0.005/hour × 730 hours/month × regional_multiplier

Where:
  prefix_length = 28, 29, 30, or 31
  regional_multiplier = 1.0 (US), 1.1 (Europe), 1.2 (Asia)
```

**Example (Europe /29 prefix)**:
```
(2^(32-29)) × $0.005 × 730 × 1.1 = 8 × $0.005 × 730 × 1.1 = $32.12/month
```

### Annual Budget Allocation

**Recommended Budget Distribution**:
```
Public IP Prefixes:       30-40% of networking budget
Load Balancers:           25-30%
VPN/ExpressRoute:         20-25%
Bandwidth/Data Transfer:  10-15%
```

---

## Cost Comparison: Prefix vs Individual IPs

### Break-Even Analysis

**Individual Public IP Pricing**: ~$3.65/month per IP

| Scenario | Individual IPs Cost | Prefix Cost | Verdict |
|----------|---------------------|-------------|---------|
| 2 IPs | $7.30/month | /31: $7.30/month | **Equal** |
| 4 IPs | $14.60/month | /30: $14.60/month | **Equal** |
| 8 IPs | $29.20/month | /29: $29.20/month | **Equal** |
| 16 IPs | $58.40/month | /28: $58.40/month | **Equal** |

**Conclusion**: From a pure cost perspective, Public IP Prefix and individual IPs are **equivalent** for Standard SKU.

### When to Choose Public IP Prefix

**Operational Benefits** (beyond cost):
1. **Simplified Firewall Management**: Single CIDR block for allowlisting
2. **Routing Efficiency**: BGP route aggregation for ExpressRoute/VPN
3. **Capacity Planning**: Reserved contiguous block prevents fragmentation
4. **Automation**: Easier to programmatically allocate from prefix vs managing individual IPs
5. **Future Growth**: Guaranteed IP availability in same block

**Recommendation**: Use Public IP Prefix when:
- You need 4+ public IPs
- You have complex firewall rules in partner networks
- You're using ExpressRoute/VPN with route filters
- You anticipate IP address growth

### When to Choose Individual Public IPs

**Better Use Cases**:
1. **Single IP Need**: One-off public IP for isolated resource
2. **Temporary Resources**: Short-lived deployments (< 30 days)
3. **Cross-Region Diversity**: IPs needed in many different regions
4. **Maximum Flexibility**: No commitment to contiguous block

---

## Hidden Costs and Considerations

### 1. Data Transfer Costs

**Public IP Prefix itself is free for data transfer**, but you pay for bandwidth:

| Traffic Type | Cost (US Regions) |
|--------------|-------------------|
| Inbound (Internet → Azure) | **FREE** |
| Outbound (first 100 GB/month) | **FREE** |
| Outbound (100 GB - 10 TB) | $0.087/GB |
| Outbound (10 TB - 50 TB) | $0.083/GB |
| Outbound (50 TB+) | $0.07/GB |

**Estimation**: A typical web application with 500 GB/month outbound:
```
First 100 GB:   $0.00
Remaining 400 GB: 400 × $0.087 = $34.80/month

Total Bandwidth Cost: $34.80/month
Public IP Prefix Cost (/30): $14.60/month
Combined Monthly Cost: $49.40/month
```

### 2. Associated Resource Costs

**Public IP Prefix enables other resources**, which have their own costs:

| Resource | Typical Monthly Cost |
|----------|---------------------|
| Standard Load Balancer | $18.25 + $0.005/rule/hour |
| VPN Gateway (Basic) | $27.38 |
| Application Gateway (Small) | $125.28 + data processing |
| Azure Firewall | $912.50 + data processing |
| NAT Gateway | $32.85 + data processing |

**Important**: These costs are **separate** from Public IP Prefix costs.

### 3. IP Prefix Resizing Costs

**Azure does NOT support in-place prefix resizing**.

**Process to resize**:
1. Create new prefix with desired size
2. Migrate resources to new prefix IPs
3. Delete old prefix

**Cost Implications**:
- **Overlap Period**: You pay for both prefixes during migration (typically 1-7 days)
- **Migration Downtime**: Potential service interruption
- **DNS TTL**: Waiting for DNS propagation (varies by TTL settings)

**Example Resize Cost**:
```
Original: /30 prefix ($14.60/month)
New: /28 prefix ($58.40/month)
Migration period: 3 days

Migration Cost:
  /30 for 3 days: $14.60 × (3/30) = $1.46
  /28 for 3 days: $58.40 × (3/30) = $5.84
  Total extra cost: ~$7.30
```

**Recommendation**: Slightly over-provision prefix size initially to avoid costly resizing.

---

## Cost Monitoring and Alerts

### Azure Cost Management Configuration

#### 1. Budget Setup

**Recommended Budget Alerts**:

```hcl
resource "azurerm_consumption_budget_resource_group" "public_ip_budget" {
  name              = "budget-public-ip-prefix"
  resource_group_id = azurerm_resource_group.this.id

  amount     = 100  # USD per month
  time_grain = "Monthly"

  notification {
    enabled   = true
    threshold = 80  # Alert at 80% budget
    operator  = "GreaterThan"

    contact_emails = [
      "cloud-ops@company.com",
      "finops@company.com"
    ]
  }

  notification {
    enabled   = true
    threshold = 100  # Alert at 100% budget
    operator  = "GreaterThan"

    contact_emails = [
      "cloud-ops@company.com",
      "finops@company.com",
      "leadership@company.com"
    ]
  }
}
```

#### 2. Cost Anomaly Detection

**Azure Monitor Alerts for Cost Spikes**:

```hcl
resource "azurerm_monitor_metric_alert" "ip_cost_spike" {
  name                = "alert-public-ip-cost-spike"
  resource_group_name = azurerm_resource_group.this.name
  scopes              = [azurerm_resource_group.this.id]
  description         = "Alert when Public IP costs increase >20% month-over-month"

  criteria {
    metric_namespace = "microsoft.insights/metrics"
    metric_name      = "ActualCost"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 120  # 20% over expected $100/month budget
  }

  frequency   = "PT1H"
  window_size = "PT1H"
}
```

#### 3. Tag-Based Cost Allocation

**Leverage terraform-namer tags for cost tracking**:

```hcl
# This module automatically applies these tags:
tags = {
  Environment = "prd"
  Contact     = "team@company.com"
  Repository  = "terraform-azurerm-public-ip-prefix"
  Workload    = "app"
  Location    = "centralus"
}
```

**Azure Cost Management Filters**:
- Group by `Environment` tag to see dev vs prd costs
- Group by `Workload` tag to allocate costs to teams
- Group by `Contact` tag for chargeback/showback

### Cost Optimization Queries

**Azure Resource Graph Query** (identify underutilized prefixes):

```kusto
resources
| where type == "microsoft.network/publicipprefixes"
| extend prefixLength = properties.prefixLength
| extend allocatedIPs = properties.ipPrefix
| extend totalIPs = pow(2, 32 - prefixLength)
| project name, resourceGroup, location, totalIPs, prefixLength, tags
| join kind=leftouter (
    resources
    | where type == "microsoft.network/publicipaddresses"
    | extend publicIPPrefix = properties.publicIPPrefix.id
    | summarize usedIPs = count() by tostring(publicIPPrefix)
) on $left.id == $right.publicIPPrefix
| extend utilization = (usedIPs * 100.0) / totalIPs
| where utilization < 50 or isnull(utilization)
| project name, resourceGroup, totalIPs, usedIPs, utilization, monthlyCost = totalIPs * 3.65
| order by monthlyCost desc
```

**Output Example**:
```
name                     | resourceGroup | totalIPs | usedIPs | utilization | monthlyCost
-------------------------|---------------|----------|---------|-------------|-------------
ippre-app-cu-dev-kmi-0  | rg-app        | 16       | 3       | 18.75%      | $58.40
ippre-web-cu-stg-kmi-0  | rg-web        | 8        | 1       | 12.50%      | $29.20
```

**Action**: Consider downsizing prefixes with <50% utilization for 90+ days.

---

## Cost Allocation and Chargeback

### Tagging Strategy for Cost Tracking

**Required Tags** (automatically applied by this module):

```hcl
module "public_ip_prefix" {
  source = "path/to/terraform-azurerm-public-ip-prefix"

  contact     = "team-platform@company.com"  # Cost center contact
  environment = "prd"                        # Environment for cost grouping
  workload    = "api-gateway"                # Application/workload name
  repository  = "platform-infrastructure"     # Source repository
  location    = "centralus"                   # Region for cost analysis

  # ... other variables
}
```

**Cost Allocation Model**:

| Tag | Purpose | Example Values |
|-----|---------|----------------|
| `Environment` | Separate dev/stg/prd costs | dev, stg, prd, sbx, tst |
| `Contact` | Chargeback to team/cost center | team-platform@company.com |
| `Workload` | Allocate to application | api-gateway, web-app, database |
| `Repository` | Link to source code/ownership | platform-infrastructure |

### Monthly Cost Report Template

**Finance/FinOps Team Report**:

```
Public IP Prefix Cost Report - October 2025

Environment: Production
Cost Center: Platform Engineering
Contact: team-platform@company.com

Resource Details:
  Name: ippre-api-gateway-cu-prd-kmi-0
  Region: Central US
  Prefix: /28 (16 IPs)
  Utilization: 12/16 IPs (75%)

Cost Breakdown:
  IP Reservation: $58.40/month
  Data Transfer (500 GB): $34.80/month
  Total: $93.20/month

Optimization Opportunities:
  - None (utilization >75%)
  - Consider zone redundancy for HA (no extra cost)

Forecast Next Month: $93.20
Annual Run Rate: $1,118.40
```

### Showback vs Chargeback

**Showback Model** (informational):
- Teams see costs but aren't directly charged
- Use for awareness and optimization incentives
- Report costs by Environment and Workload tags

**Chargeback Model** (financial):
- Teams/departments are billed for actual usage
- Use Contact tag for cost center identification
- Implement automated billing integration

**Recommendation**: Start with showback for 3-6 months, then transition to chargeback once teams understand cost drivers.

---

## Cost Estimation Examples

### Example 1: Small E-Commerce Site

**Requirements**:
- 3 public IPs (web servers + load balancer)
- US East region
- Production environment
- Expected traffic: 200 GB/month outbound

**Configuration**:
```hcl
module "public_ip_prefix" {
  source = "path/to/terraform-azurerm-public-ip-prefix"

  contact             = "ecommerce-team@company.com"
  environment         = "prd"
  location            = "eastus"
  repository          = "ecommerce-infrastructure"
  workload            = "webstore"
  resource_group_name = "rg-ecommerce-eus-prd-kmi-0"

  prefix_length      = 30  # 4 IPs (25% buffer for growth)
  availability_zones = ["1", "2", "3"]  # Zone-redundant
}
```

**Monthly Costs**:
```
Public IP Prefix (/30):         $14.60
Outbound Data (200 GB):
  First 100 GB:                 $0.00
  Next 100 GB @ $0.087/GB:      $8.70
Total Monthly Cost:             $23.30

Annual Cost: $279.60
```

### Example 2: Multi-Tier SaaS Application

**Requirements**:
- 12 public IPs (API gateway, web tier, admin portal, monitoring)
- Europe West region
- Production + Staging environments
- Expected traffic: 1.5 TB/month outbound

**Configuration**:

```hcl
# Production
module "public_ip_prefix_prd" {
  source = "path/to/terraform-azurerm-public-ip-prefix"

  contact             = "saas-platform@company.com"
  environment         = "prd"
  location            = "westeurope"
  repository          = "saas-platform"
  workload            = "api"
  resource_group_name = "rg-saas-weu-prd-kmi-0"

  prefix_length      = 28  # 16 IPs (33% buffer)
  availability_zones = ["1", "2", "3"]
}

# Staging
module "public_ip_prefix_stg" {
  source = "path/to/terraform-azurerm-public-ip-prefix"

  contact             = "saas-platform@company.com"
  environment         = "stg"
  location            = "westeurope"
  repository          = "saas-platform"
  workload            = "api"
  resource_group_name = "rg-saas-weu-stg-kmi-0"

  prefix_length      = 30  # 4 IPs
  availability_zones = ["1", "2", "3"]
}
```

**Monthly Costs** (Europe pricing +10%):
```
Production Public IP Prefix (/28):  $64.24
Staging Public IP Prefix (/30):     $16.06
Outbound Data (1.5 TB):
  First 100 GB:                     $0.00
  Next 900 GB @ $0.087/GB:          $78.30
  Next 500 GB @ $0.087/GB:          $43.50
Subtotal Data:                      $121.80

Total Monthly Cost:                 $202.10
Annual Cost: $2,425.20
```

### Example 3: Global Financial Services Platform

**Requirements**:
- 40+ public IPs across 3 regions (primary, DR, compliance)
- US East, Europe West, Asia Southeast
- Multi-environment (prd, stg, tst)
- Expected traffic: 10 TB/month outbound
- High availability and compliance requirements

**Configuration**:

```hcl
# Production - US East (Primary)
module "public_ip_prefix_prd_us" {
  source              = "path/to/terraform-azurerm-public-ip-prefix"
  environment         = "prd"
  location            = "eastus"
  prefix_length       = 28  # 16 IPs
  availability_zones  = ["1", "2", "3"]
  # ... other variables
}

# Production - Europe West (DR)
module "public_ip_prefix_prd_eu" {
  source              = "path/to/terraform-azurerm-public-ip-prefix"
  environment         = "prd"
  location            = "westeurope"
  prefix_length       = 28  # 16 IPs
  availability_zones  = ["1", "2", "3"]
  # ... other variables
}

# Production - Asia Southeast (Compliance)
module "public_ip_prefix_prd_asia" {
  source              = "path/to/terraform-azurerm-public-ip-prefix"
  environment         = "prd"
  location            = "southeastasia"
  prefix_length       = 28  # 16 IPs
  availability_zones  = ["1", "2", "3"]
  # ... other variables
}

# Staging - US East
module "public_ip_prefix_stg_us" {
  source              = "path/to/terraform-azurerm-public-ip-prefix"
  environment         = "stg"
  location            = "eastus"
  prefix_length       = 29  # 8 IPs
  availability_zones  = ["1", "2", "3"]
  # ... other variables
}

# Testing - US East
module "public_ip_prefix_tst_us" {
  source              = "path/to/terraform-azurerm-public-ip-prefix"
  environment         = "tst"
  location            = "eastus"
  prefix_length       = 30  # 4 IPs
  availability_zones  = []  # Non-zonal for cost savings (testing only)
  # ... other variables
}
```

**Monthly Costs**:
```
Production IPs:
  US East (/28):                    $58.40
  Europe West (/28) @ 1.1x:         $64.24
  Asia Southeast (/28) @ 1.2x:      $70.08

Non-Production IPs:
  Staging US (/29):                 $29.20
  Testing US (/30):                 $14.60

Subtotal IP Reservations:           $236.52

Outbound Data (10 TB):
  First 100 GB:                     $0.00
  Next 9.9 TB @ $0.083/GB:          $821.70

Total Monthly Cost:                 $1,058.22
Annual Cost: $12,698.64
```

**Cost Optimization Recommendations**:
1. Consider IPv6 for internal region-to-region traffic (could save 30-40% on data transfer)
2. Implement Azure Front Door to reduce inter-region bandwidth costs
3. Use CDN for static content to minimize origin data transfer
4. Review testing environment - could downsize to /31 (2 IPs) if only need minimal allocation

---

## Long-Term Cost Projections

### 3-Year Total Cost of Ownership (TCO)

#### Small Deployment (/30 Prefix - 4 IPs)

| Year | Monthly Avg | Annual Cost | Cumulative |
|------|-------------|-------------|------------|
| 1 | $14.60 | $175.20 | $175.20 |
| 2 | $15.04 (3% inflation) | $180.48 | $355.68 |
| 3 | $15.49 (3% inflation) | $185.88 | $541.56 |

**3-Year TCO**: $541.56

#### Medium Deployment (/28 Prefix - 16 IPs)

| Year | Monthly Avg | Annual Cost | Cumulative |
|------|-------------|-------------|------------|
| 1 | $58.40 | $700.80 | $700.80 |
| 2 | $60.15 (3% inflation) | $721.80 | $1,422.60 |
| 3 | $61.95 (3% inflation) | $743.40 | $2,166.00 |

**3-Year TCO**: $2,166.00

### Growth Scenario Planning

**Scenario**: Start with /30, grow to /28 over 3 years

```
Year 1: /30 prefix (4 IPs)
  Monthly: $14.60
  Annual: $175.20

Year 2: Migrate to /29 (8 IPs)
  Monthly: $29.20
  Annual: $350.40
  Migration cost: $7.30 (one-time)

Year 3: Migrate to /28 (16 IPs)
  Monthly: $58.40
  Annual: $700.80
  Migration cost: $14.60 (one-time)

Total 3-Year Cost: $175.20 + $350.40 + $700.80 + $21.90 = $1,248.30
```

**Alternative**: Start with /28 (16 IPs) from day one

```
3-Year Cost: $700.80 × 3 = $2,102.40

Cost Comparison:
  Grow-as-needed approach: $1,248.30
  Right-size from start:   $2,102.40
  Difference: $854.10 saved by growing incrementally

  BUT: 2 migrations required, potential downtime, operational overhead
```

**Recommendation**: If you expect >50% IP growth within 12 months, provision target size upfront to avoid migration costs and complexity.

---

## Recommendations Summary

### Cost Optimization Best Practices

1. **Right-Size Aggressively**: Start with smallest prefix that meets current needs + 25% buffer
2. **Leverage IPv6**: Use IPv6 prefixes wherever possible (FREE vs $58.40/month for /28)
3. **Use Zone Redundancy**: Always enable availability zones (no extra cost, better SLA)
4. **Tag Religiously**: Ensure all resources have Contact, Environment, Workload tags for cost allocation
5. **Monitor Utilization**: Set up alerts for prefixes with <50% utilization for 60+ days
6. **Consolidate Regions**: Avoid multi-region prefix allocation unless required for DR/compliance
7. **Environment Sizing**: Use different prefix sizes per environment (prod=/28, stg=/30, dev=/31)
8. **Forecast Growth**: Budget for 3-6 month growth to avoid costly mid-year migrations

### When to Use This Module

**✅ Good Fit**:
- Need 4+ public IPs in same region
- Require contiguous IP block for routing/firewall rules
- Anticipate IP address growth
- Use ExpressRoute/VPN with route aggregation
- Want simplified IP lifecycle management

**❌ Not a Good Fit**:
- Need only 1-2 public IPs (use individual IPs)
- Temporary/short-lived deployments (<30 days)
- IPs scattered across many regions
- Extremely cost-sensitive with no growth plans

### Cost Alert Thresholds

**Recommended Azure Cost Management Alerts**:

| Alert Type | Threshold | Action |
|------------|-----------|--------|
| Budget Alert | 80% of monthly budget | Review usage, forecast overrun |
| Budget Alert | 100% of monthly budget | Immediate review, potential freeze |
| Anomaly Detection | 20% increase MoM | Investigate unexpected growth |
| Utilization Alert | <50% for 60 days | Consider downsizing prefix |
| Utilization Alert | >90% for 7 days | Plan prefix expansion |

---

## Appendix: Pricing Data Sources

### Azure Pricing Calculator

- **URL**: https://azure.microsoft.com/en-us/pricing/calculator/
- **Last Updated**: October 2025
- **Disclaimer**: Pricing subject to change; always verify current rates

### Regional Pricing Multipliers

| Region | Multiplier | Examples |
|--------|------------|----------|
| US (East, West, Central) | 1.0x | Base pricing |
| Europe (North, West) | 1.1x | +10% premium |
| UK (South, West) | 1.1x | +10% premium |
| Asia (Southeast, East) | 1.2x | +20% premium |
| Australia (East, Southeast) | 1.25x | +25% premium |
| Brazil South | 1.3x | +30% premium |

### Cost Calculation Formula Reference

**Per IP Per Month**:
```
cost_per_ip_per_month = $0.005/hour × 730 hours/month = $3.65/month
```

**Prefix Total Cost**:
```
prefix_monthly_cost = (2^(32 - prefix_length)) × $3.65 × regional_multiplier
```

**Examples**:
- /28 US: (2^4) × $3.65 × 1.0 = 16 × $3.65 = **$58.40**
- /29 Europe: (2^3) × $3.65 × 1.1 = 8 × $3.65 × 1.1 = **$32.12**
- /30 Asia: (2^2) × $3.65 × 1.2 = 4 × $3.65 × 1.2 = **$17.52**

---

## Document Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-28 | Initial cost analysis for terraform-azurerm-public-ip-prefix module |

---

**For questions about this cost analysis, contact**:
- **Module Owner**: Refer to module README.md
- **Cost Optimization**: FinOps team
- **Azure Pricing Updates**: https://azure.microsoft.com/pricing/
