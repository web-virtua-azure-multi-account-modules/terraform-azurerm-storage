variable "name" {
  description = "Storage account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "storage_type" {
  description = "Account tier type for storage account, options are Standard and Premium, for BlockBlobStorage and FileStorage accounts only Premium is valid"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Account replication type for storage account, the options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  type        = string
  default     = "LRS"
}

variable "use_tags_default" {
  description = "If true will be use the tags default to resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to storage account"
  type        = map(any)
  default     = {}
}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "cross_tenant_replication_enabled" {
  description = "If true, should cross Tenant replication be enabled"
  type        = bool
  default     = true
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot"
  type        = string
  default     = "Hot"
}

variable "edge_zone" {
  description = "Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created"
  type        = string
  default     = null
}

variable "enable_https_traffic_only" {
  description = "Flag which forces HTTPS if enabled, see here for more information"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2"
  type        = string
  default     = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within this Account to opt into being public"
  type        = bool
  default     = true
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD)"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether the public network access is enabled"
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account"
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created"
  type        = bool
  default     = false
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled? Changing this forces a new resource to be created"
  type        = bool
  default     = false
}

variable "large_file_share_enabled" {
  description = "If true Large File Share Enabled"
  type        = bool
  default     = null
}

variable "queue_encryption_key_type" {
  description = "The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created"
  type        = string
  default     = "Service"
}

variable "table_encryption_key_type" {
  description = "The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created"
  type        = string
  default     = "Service"
}

variable "infrastructure_encryption_enabled" {
  description = "Is infrastructure encryption enabled? Changing this forces a new resource to be created"
  type        = bool
  default     = false
}

variable "allowed_copy_scope" {
  description = "Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are AAD and PrivateLink"
  type        = string
  default     = null
}

variable "sftp_enabled" {
  description = "If true, enable SFTP for the storage account"
  type        = bool
  default     = null
}

variable "has_threat_protection" {
  description = "If true enable advanced threat protection"
  type        = bool
  default     = false
}

variable "identity" {
  description = "Managed Service Identity on Storage Account"
  type = object({
    type         = string           # Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)
    identity_ids = optional(string) # Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account
  })
  default = null
}

variable "static_website" {
  description = "Configuration to static website"
  type = object({
    index_document     = optional(string) # The webpage that Azure Storage serves for requests to the root of a website or any subfolder. For example, index.html. The value is case-sensitive
    error_404_document = optional(string) # The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file
  })
  default = null
}

variable "custom_domain" {
  description = "Custom domain to use for the Storage Account"
  type = object({
    name          = string         # The Custom Domain Name to use for the Storage Account, which will be validated by Azure
    use_subdomain = optional(bool) # Should the Custom Domain Name be validated by using indirect CNAME validation
  })
  default = null
}

variable "blob_properties" {
  description = "Blob properties to storage account"
  type = object({
    versioning_enabled                     = optional(bool, false) # If versioning enabled
    change_feed_enabled                    = optional(bool, false) # Is the blob service properties for change feed events enabled
    change_feed_retention_in_days          = optional(number)      # The duration of change feed events retention in days. The possible values are between 1 and 146000 days (400 years)
    default_service_version                = optional(string)      # The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version
    last_access_time_enabled               = optional(bool, false) # Is the last access time based tracking enabled
    delete_retention_policy_days           = optional(number)      # Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7
    restore_policy_days                    = optional(number)      # Specifies the number of days that the blob can be restored, between 1 and 365 days. This must be less than the days specified for delete_retention_policy
    container_delete_retention_policy_days = optional(number)      # Specifies the number of days that the container should be retained, between 1 and 365 days. Defaults to 7

    cors_rule = optional(object({
      allowed_headers    = list(string) # A list of headers that are allowed to be a part of the cross-origin request
      allowed_methods    = list(string) # A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH
      allowed_origins    = list(string) # A list of origin domains that will be allowed by CORS
      exposed_headers    = list(string) # A list of response headers that are exposed to CORS clients
      max_age_in_seconds = list(string) # The number of seconds the client should cache a preflight response
    }))
  })
  default = null
}

variable "queue_properties" {
  description = "Queue properties to configure logs and metrics"
  type = object({
    cors_rule = optional(object({
      allowed_headers    = list(string) # A list of headers that are allowed to be a part of the cross-origin request
      allowed_methods    = list(string) # A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH
      allowed_origins    = list(string) # A list of origin domains that will be allowed by CORS
      exposed_headers    = list(string) # A list of response headers that are exposed to CORS clients
      max_age_in_seconds = list(string) # The number of seconds the client should cache a preflight response
    }))

    logging = optional(object({
      retention_policy_days = optional(number, 7)     # Specifies the number of days that logs will be retained
      delete                = optional(bool, true)    # Indicates whether all delete requests should be logged
      read                  = optional(bool, true)    # Indicates whether all read requests should be logged
      write                 = optional(bool, true)    # Indicates whether all write requests should be logged
      version               = optional(string, "1.0") # The version of storage analytics to configure
    }))

    minute_metrics = optional(object({
      enabled               = bool             # Indicates whether hour metrics are enabled for the Queue service
      version               = string           # The version of storage analytics to configure
      include_apis          = optional(bool)   # Indicates whether metrics should generate summary statistics for called API operations
      retention_policy_days = optional(number) # Specifies the number of days that logs will be retained
    }))

    hour_metrics = optional(object({
      enabled               = bool             # Indicates whether hour metrics are enabled for the Queue service
      version               = string           # The version of storage analytics to configure
      include_apis          = optional(bool)   # Indicates whether metrics should generate summary statistics for called API operations
      retention_policy_days = optional(number) # Specifies the number of days that logs will be retained
    }))
  })
  default = null
}

variable "share_properties" {
  description = "Share properties"
  type = object({
    retention_policy_days = optional(number) # Specifies the number of days that the azurerm_storage_share should be retained, between 1 and 365 days. Defaults to 7

    cors_rule = optional(object({
      allowed_headers    = list(string) # A list of headers that are allowed to be a part of the cross-origin request
      allowed_methods    = list(string) # A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH
      allowed_origins    = list(string) # A list of origin domains that will be allowed by CORS
      exposed_headers    = list(string) # A list of response headers that are exposed to CORS clients
      max_age_in_seconds = list(string) # The number of seconds the client should cache a preflight response
    }))

    smb = object({
      authentication_types            = optional(string)       # A set of SMB authentication methods. Possible values are NTLMv2, and Kerberos
      channel_encryption_type         = optional(string)       # A set of SMB channel encryption. Possible values are AES-128-CCM, AES-128-GCM, and AES-256-GCM
      kerberos_ticket_encryption_type = optional(string)       # A set of Kerberos ticket encryption. Possible values are RC4-HMAC, and AES-256
      versions                        = optional(list(string)) # A set of SMB protocol versions. Possible values are SMB2.1, SMB3.0, and SMB3.1.1
      multichannel_enabled            = optional(bool)         # Indicates whether multichannel is enabled. Defaults to false. This is only supported on Premium storage accounts
    })
  })
  default = null
}

variable "azure_files_authentication" {
  description = "Azure files authentication"
  type = object({
    directory_type = string # pecifies the directory service used. Possible values are AADDS, AD and AADKERB

    active_directory = object({
      domain_name         = string           # Specifies the primary domain that the AD DNS server is authoritative for
      domain_guid         = string           # Specifies the domain GUID
      domain_sid          = optional(string) # Specifies the security identifier (SID). This is required when directory_type is set to AD
      storage_sid         = optional(string) # Specifies the security identifier (SID) for Azure Storage. This is required when directory_type is set to AD
      forest_name         = optional(string) # Specifies the Active Directory forest. This is required when directory_type is set to AD
      netbios_domain_name = optional(string) # Specifies the NetBIOS domain name. This is required when directory_type is set to AD
    })
  })
  default = null
}

variable "network_rules" {
  description = "Network rules"
  type = object({
    default_action             = string                 # Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow
    ip_rules                   = optional(list(string)) # List of public IP or IP ranges in CIDR Format. Only IPv4 addresses are allowed. /31 CIDRs, /32 CIDRs, and Private IP address ranges (as defined in RFC 1918), are not allowed
    bypass                     = optional(list(string)) # Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None
    virtual_network_subnet_ids = optional(list(string)) # A list of resource ids for subnets

    private_link_access = object({
      endpoint_resource_id = string           # The resource id of the resource access rule to be granted access
      endpoint_tenant_id   = optional(string) # The tenant id of the resource of the resource access rule to be granted access. Defaults to the current tenant id
    })
  })
  default = null
}

variable "customer_managed_key" {
  description = "Customer managed key"
  type = object({
    key_vault_key_id          = string # The ID of the Key Vault Key, supplying a version-less key ID will enable auto-rotation of this key
    user_assigned_identity_id = string # The ID of a user assigned identity
  })
  default = null
}

variable "routing" {
  description = "Routing endpoints"
  type = object({
    publish_internet_endpoints  = optional(bool)   # Should internet routing storage endpoints be published? Defaults to false
    publish_microsoft_endpoints = optional(bool)   # Should Microsoft routing storage endpoints be published? Defaults to false
    choice                      = optional(string) # Specifies the kind of network routing opted by the user. Possible values are InternetRouting and MicrosoftRouting. Defaults to MicrosoftRouting
  })
  default = null
}

variable "immutability_policy" {
  description = "Immutability policy"
  type = object({
    allow_protected_append_writes = bool   # When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted
    state                         = string # Defines the mode of the policy. Disabled state disables the policy, Unlocked state allows increase and decrease of immutability retention time and also allows toggling allowProtectedAppendWrites property, Locked state only allows the increase of the immutability retention time. A policy can only be created in a Disabled or Unlocked state and can be toggled between the two states. Only a policy in an Unlocked state can transition to a Locked state which cannot be reverted
    period_since_creation_in_days = number # The immutability period for the blobs in the container since the policy creation, in days
  })
  default = null
}

variable "sas_policy" {
  description = "SAS policy"
  type = object({
    expiration_period = string           # The SAS expiration period in format of DD.HH:MM:SS
    expiration_action = optional(string) # The SAS expiration action. The only possible value is Log at this moment. Defaults to Log
  })
  default = null
}

variable "storage_containers" {
  description = "Storage containers list"
  type = list(object({
    name                  = string
    container_access_type = optional(string, "private") # The Access Level configured for this Container. Possible values are blob, container or private
    metadata              = optional(map(any), {})      # A mapping of MetaData for this Container. All metadata keys should be lowercase.
  }))
  default = null
}
