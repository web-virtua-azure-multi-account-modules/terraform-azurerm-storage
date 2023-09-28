# Azure Storage Accont and Storage Container for multiples accounts with Terraform module
* This module simplifies creating and configuring of Storage Accont and Storage Container across multiple accounts on Azure

* Is possible use this module with one account using the standard profile or multi account using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Criate file provider.tf with the exemple code below:
```hcl
provider "azurerm" {
  alias   = "alias_profile_a"

  features {}
}

provider "azurerm" {
  alias   = "alias_profile_b"

  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}
```


## Features enable of Compartment configurations for this module:

- Storage account
- Storage container
- Advanced threat protection

## Usage exemples


### Create storage account with two containers

```hcl
module "storage_account_test" {
  source = "web-virtua-azure-multi-account-modules/storage/azurerm"

  name     = "storageaccounttest"
  resource_group_name = var.resource_group_name

  storage_containers = [
    {
      name                  = "container-1"
    },
    {
      name                  = "container-2"
    }
  ]

  providers = {
    azurerm = azurerm.alias_profile_a
  }
}
```

### Create storage account with one containers and logs configuration

```hcl
module "storage_account_test" {
  source = "web-virtua-azure-multi-account-modules/storage/azurerm"

  name     = "storageaccounttest"
  resource_group_name = var.resource_group_name

  storage_containers = [
    {
      name                  = "container-1"
      container_access_type = "private"
    }
  ]

  queue_properties = {
    logging = {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 7
    }
  }

  providers = {
    azurerm = azurerm.alias_profile_b
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name | `string` | `-` | yes | Storage account name | `-` |
| name | `string` | `-` | yes | Resource group name | `-` |
| storage_type | `string` | `Standard` | no | Account tier type for storage account, options are Standard and Premium, for BlockBlobStorage and FileStorage accounts only Premium is valid | `*`Standard <br> `*`Premium |
| storage_replication_type | `string` | `LRS` | no | Account replication type for storage account, the options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS | `*`LRS <br> `*`GRS `*`RAGRS <br> `*`ZRS `*`GZRS <br> `*`RAGZRS |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to resources | `*`false <br> `*`true |
| tags | `map(any)` | `{}` | no | Tags to compartment | `-` |
| account_kind | `string` | `StorageV2` | no | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `*`BlobStorage <br> `*`BlockBlobStorage `*`FileStorage <br> `*`Storage `*`StorageV2  |
| cross_tenant_replication_enabled | `bool` | `true` | no | If true, should cross Tenant replication be enabled | `*`false <br> `*`true |
| access_tier | `string` | `Hot` | no | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot | `*`Hot <br> `*`Cool |
| edge_zone | `string` | `null` | no | Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created | `-` |
| enable_https_traffic_only | `bool` | `true` | no | Flag which forces HTTPS if enabled, see here for more information | `*`false <br> `*`true |
| min_tls_version | `string` | `TLS1_2` | no | The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2 | `*`TLS1_0 <br> `*`TLS1_1 <br> `*`TLS1_2 |
| allow_nested_items_to_be_public | `bool` | `true` | no | Allow or disallow nested items within this Account to opt into being public | `*`false <br> `*`true |
| shared_access_key_enabled | `bool` | `true` | no | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD) | `*`false <br> `*`true |
| public_network_access_enabled | `bool` | `true` | no | Whether the public network access is enabled | `*`false <br> `*`true |
| default_to_oauth_authentication | `bool` | `false` | no | Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account | `*`false <br> `*`true |
| is_hns_enabled | `bool` | `false` | no | Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created | `*`false <br> `*`true |
| nfsv3_enabled | `bool` | `false` | no | Is NFSv3 protocol enabled? Changing this forces a new resource to be created | `*`false <br> `*`true |
| large_file_share_enabled | `bool` | `null` | no | If true Large File Share Enabled | `*`false <br> `*`true |
| queue_encryption_key_type | `string` | `Service` | no | The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created | `*`Service <br> `*`Account |
| table_encryption_key_type | `string` | `Service` | no | The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created | `*`Service <br> `*`Account |
| infrastructure_encryption_enabled | `bool` | `false` | no | Is infrastructure encryption enabled? Changing this forces a new resource to be created | `*`false <br> `*`true |
| allowed_copy_scope | `string` | `null` | no | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are AAD and PrivateLink | `*`AAD <br> `*`PrivateLink |
| sftp_enabled | `bool` | `null` | no | If true, enable SFTP for the storage account | `*`false <br> `*`true |
| has_threat_protection | `bool` | `false` | no | If true enable advanced threat protection | `*`false <br> `*`true |
| identity | `object` | `null` | no | Managed Service Identity on Storage Account | `-` |
| static_website | `object` | `null` | no | Configuration to static website | `-` |
| custom_domain | `object` | `null` | no | Custom domain to use for the Storage Account | `-` |
| blob_properties | `object` | `null` | no | Blob properties to storage account | `-` |
| queue_properties | `object` | `null` | no | Queue properties to configure logs and metrics | `-` |
| share_properties | `object` | `null` | no | Share properties | `-` |
| azure_files_authentication | `object` | `null` | no | Azure files authentication | `-` |
| network_rules | `object` | `null` | no | Network rules | `-` |
| customer_managed_key | `object` | `null` | no | Customer managed key | `-` |
| routing | `object` | `null` | no | Routing endpoints | `-` |
| immutability_policy | `object` | `null` | no | Immutability policy | `-` |
| sas_policy | `object` | `null` | no | SAS policy | `-` |
| storage_containers | `object` | `null` | no | Storage containers list | `-` |

* Model of identity variable
```hcl
variable "identity" {
  description = "Managed Service Identity on Storage Account"
  type = object({
    type         = string
    identity_ids = optional(string)
  })
  default = null
}
```

* Model of static_website variable
```hcl
variable "static_website" {
  description = "Configuration to static website"
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null
}
```

* Model of custom_domain variable
```hcl
variable "custom_domain" {
  description = "Custom domain to use for the Storage Account"
  type = object({
    name          = string
    use_subdomain = optional(bool)
  })
  default = null
}
```

* Model of blob_properties variable
```hcl
variable "blob_properties" {
  description = "Blob properties to storage account"
  type = object({
    versioning_enabled                     = optional(bool, false)
    change_feed_enabled                    = optional(bool, false)
    change_feed_retention_in_days          = optional(number)
    default_service_version                = optional(string)
    last_access_time_enabled               = optional(bool, false)
    delete_retention_policy_days           = optional(number)
    restore_policy_days                    = optional(number)
    container_delete_retention_policy_days = optional(number)

    cors_rule = optional(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = list(string)
    }))
  })
  default = null
}
```

* Model of queue_properties variable
```hcl
variable "queue_properties" {
  description = "Queue properties to configure logs and metrics"
  type = object({
    cors_rule = optional(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = list(string)
    }))

    logging = optional(object({
      delete                = bool
      read                  = bool
      write                 = bool
      version               = string
      retention_policy_days = optional(number)
    }))

    minute_metrics = optional(object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    }))

    hour_metrics = optional(object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    }))
  })
  default = null
}
```

* Model of share_properties variable
```hcl
variable "share_properties" {
  description = "Share properties"
  type = object({
    retention_policy_days = optional(number)

    cors_rule = optional(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = list(string)
    }))

    smb = object({
      authentication_types            = optional(string)
      channel_encryption_type         = optional(string)
      kerberos_ticket_encryption_type = optional(string)
      versions                        = optional(list(string))
      multichannel_enabled            = optional(bool)
    })
  })
  default = null
}
```

* Model of azure_files_authentication variable
```hcl
variable "azure_files_authentication" {
  description = "Azure files authentication"
  type = object({
    directory_type = string

    active_directory = object({
      domain_name         = string
      domain_guid         = string
      domain_sid          = optional(string)
      storage_sid         = optional(string)
      forest_name         = optional(string)
      netbios_domain_name = optional(string)
    })
  })
  default = null
}
```

* Model of network_rules variable
```hcl
variable "network_rules" {
  description = "Network rules"
  type = object({
    default_action             = string
    ip_rules                   = optional(list(string))
    bypass                     = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))

    private_link_access = object({
      endpoint_resource_id = string 
      endpoint_tenant_id   = optional(string)
    })
  })
  default = null
}
```

* Model of customer_managed_key variable
```hcl
variable "customer_managed_key" {
  description = "Customer managed key"
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = string
  })
  default = null
}
```

* Model of routing variable
```hcl
variable "routing" {
  description = "Routing endpoints"
  type = object({
    publish_internet_endpoints  = optional(bool)
    publish_microsoft_endpoints = optional(bool)
    choice                      = optional(string)
  })
  default = null
}
```

* Model of immutability_policy variable
```hcl
variable "immutability_policy" {
  description = "Immutability policy"
  type = object({
    allow_protected_append_writes = bool
    state                         = string 
    period_since_creation_in_days = number
  })
  default = null
}
```

* Model of sas_policy variable
```hcl
variable "sas_policy" {
  description = "SAS policy"
  type = object({
    expiration_period = string
    expiration_action = optional(string)
  })
  default = null
}
```

* Model of storage_containers variable
```hcl
variable "storage_containers" {
  description = "Storage containers list"
  type = list(object({
    name                  = string
    container_access_type = optional(string, "private")
    metadata              = optional(map(any), {})
  }))
  default = null
}
```


## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.create_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_advanced_threat_protection.create_threat_protection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |
| [azurerm_storage_container.storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `storage_account` | Storage account |
| `storage_account_id` | Storage account ID |
| `storage_account_name` | Storage account name |
| `storage_account_identity` | Storage account identity block |
| `storage_account_network_rules` | Network rules of the associated storage account |
| `threat_protection` | Advanced threat protection |
| `storage_containers` | Storage containers |
| `storage_containers_ids` | Storage containers IDs |
