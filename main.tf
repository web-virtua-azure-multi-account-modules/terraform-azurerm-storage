locals {
  tags_storage_account = {
    "tf-name" = var.name
    "tf-type" = "storage-account"
  }
}

data "azurerm_resource_group" "get_resource_group" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "create_storage_account" {
  name                              = var.name
  resource_group_name               = data.azurerm_resource_group.get_resource_group.name
  location                          = data.azurerm_resource_group.get_resource_group.location
  account_tier                      = var.storage_type
  account_replication_type          = var.storage_replication_type
  account_kind                      = var.account_kind
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  access_tier                       = var.access_tier
  edge_zone                         = var.edge_zone
  enable_https_traffic_only         = var.enable_https_traffic_only
  min_tls_version                   = var.min_tls_version
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  is_hns_enabled                    = var.is_hns_enabled
  nfsv3_enabled                     = var.nfsv3_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  queue_encryption_key_type         = var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  allowed_copy_scope                = var.allowed_copy_scope
  sftp_enabled                      = var.sftp_enabled
  tags                              = merge(var.tags, var.use_tags_default ? local.tags_storage_account : {})

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "static_website" {
    for_each = var.static_website != null ? [1] : []

    content {
      index_document     = var.static_website.index_document
      error_404_document = var.static_website.error_404_document
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain != null ? [1] : []

    content {
      name          = var.custom_domain.name
      use_subdomain = var.custom_domain.use_subdomain
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_properties != null ? [1] : []

    content {
      versioning_enabled            = var.blob_properties.versioning_enabled
      change_feed_enabled           = var.blob_properties.change_feed_enabled
      change_feed_retention_in_days = var.blob_properties.change_feed_retention_in_days
      default_service_version       = var.blob_properties.default_service_version
      last_access_time_enabled      = var.blob_properties.last_access_time_enabled

      dynamic "cors_rule" {
        for_each = var.blob_properties.cors_rule != null ? [1] : []

        content {
          allowed_headers    = var.blob_properties.cors_rule.allowed_headers
          allowed_methods    = var.blob_properties.cors_rule.allowed_methods
          allowed_origins    = var.blob_properties.cors_rule.allowed_origins
          exposed_headers    = var.blob_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.blob_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.blob_properties.delete_retention_policy_days != null ? [1] : []

        content {
          days = var.blob_properties.delete_retention_policy_days
        }
      }

      dynamic "restore_policy" {
        for_each = var.blob_properties.restore_policy_days != null ? [1] : []

        content {
          days = var.blob_properties.restore_policy_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.blob_properties.container_delete_retention_policy_days != null ? [1] : []

        content {
          days = var.blob_properties.container_delete_retention_policy_days
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties != null ? [1] : []

    content {
      dynamic "cors_rule" {
        for_each = var.queue_properties.cors_rule != null ? [1] : []

        content {
          allowed_headers    = var.queue_properties.cors_rule.allowed_headers
          allowed_methods    = var.queue_properties.cors_rule.allowed_methods
          allowed_origins    = var.queue_properties.cors_rule.allowed_origins
          exposed_headers    = var.queue_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.queue_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = var.queue_properties.logging != null ? [1] : []

        content {
          delete                = var.queue_properties.logging.delete
          read                  = var.queue_properties.logging.read
          write                 = var.queue_properties.logging.write
          version               = var.queue_properties.logging.version
          retention_policy_days = var.queue_properties.logging.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = var.queue_properties.minute_metrics != null ? [1] : []

        content {
          enabled               = var.queue_properties.minute_metrics.enabled
          version               = var.queue_properties.minute_metrics.version
          include_apis          = var.queue_properties.minute_metrics.include_apis
          retention_policy_days = var.queue_properties.minute_metrics.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = var.queue_properties.hour_metrics != null ? [1] : []

        content {
          enabled               = var.queue_properties.hour_metrics.enabled
          version               = var.queue_properties.hour_metrics.version
          include_apis          = var.queue_properties.hour_metrics.include_apis
          retention_policy_days = var.queue_properties.hour_metrics.retention_policy_days
        }
      }
    }
  }

  dynamic "share_properties" {
    for_each = var.share_properties != null ? [1] : []

    content {
      dynamic "cors_rule" {
        for_each = var.share_properties.cors_rule != null ? [1] : []

        content {
          allowed_headers    = var.share_properties.cors_rule.allowed_headers
          allowed_methods    = var.share_properties.cors_rule.allowed_methods
          allowed_origins    = var.share_properties.cors_rule.allowed_origins
          exposed_headers    = var.share_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.share_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = var.share_properties.retention_policy_days != null ? [1] : []

        content {
          days = var.share_properties.retention_policy_days
        }
      }

      dynamic "smb" {
        for_each = var.share_properties.smb != null ? [1] : []

        content {
          authentication_types            = var.share_properties.smb.authentication_types
          channel_encryption_type         = var.share_properties.smb.channel_encryption_type
          kerberos_ticket_encryption_type = var.share_properties.smb.kerberos_ticket_encryption_type
          versions                        = var.share_properties.smb.versions
          multichannel_enabled            = var.share_properties.smb.multichannel_enabled
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication != null ? [1] : []

    content {
      directory_type = var.azure_files_authentication.directory_type

      dynamic "active_directory" {
        for_each = var.azure_files_authentication.active_directory != null ? [1] : []

        content {
          domain_name         = var.azure_files_authentication.active_directory.domain_name
          domain_guid         = var.azure_files_authentication.active_directory.domain_guid
          domain_sid          = var.azure_files_authentication.active_directory.domain_sid
          storage_sid         = var.azure_files_authentication.active_directory.storage_sid
          forest_name         = var.azure_files_authentication.active_directory.forest_name
          netbios_domain_name = var.azure_files_authentication.active_directory.netbios_domain_name
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [1] : []

    content {
      default_action             = var.network_rules.default_action
      ip_rules                   = var.network_rules.ip_rules
      bypass                     = var.network_rules.bypass
      virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = var.network_rules.private_link_access != null ? [1] : []

        content {
          endpoint_resource_id = var.network_rules.private_link_access.endpoint_resource_id
          endpoint_tenant_id   = var.network_rules.private_link_access.endpoint_tenant_id
        }
      }
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [1] : []

    content {
      key_vault_key_id          = var.customer_managed_key.key_vault_key_id
      user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
    }
  }

  dynamic "routing" {
    for_each = var.routing != null ? [1] : []

    content {
      publish_internet_endpoints  = var.routing.publish_internet_endpoints
      publish_microsoft_endpoints = var.routing.publish_microsoft_endpoints
      choice                      = var.routing.choice
    }
  }

  dynamic "immutability_policy" {
    for_each = var.immutability_policy != null ? [1] : []

    content {
      allow_protected_append_writes = var.immutability_policy.allow_protected_append_writes
      state                         = var.immutability_policy.state
      period_since_creation_in_days = var.immutability_policy.period_since_creation_in_days
    }
  }

  dynamic "sas_policy" {
    for_each = var.sas_policy != null ? [1] : []

    content {
      expiration_period = var.sas_policy.expiration_period
      expiration_action = var.sas_policy.expiration_action
    }
  }
}

resource "azurerm_advanced_threat_protection" "create_threat_protection" {
  count = var.has_threat_protection ? 1 : 0

  enabled            = true
  target_resource_id = azurerm_storage_account.create_storage_account.id
}

resource "azurerm_storage_container" "storage_container" {
  count = var.storage_containers != null ? length(var.storage_containers) : 0

  storage_account_name  = azurerm_storage_account.create_storage_account.name
  name                  = var.storage_containers[count.index].name
  container_access_type = var.storage_containers[count.index].container_access_type
  metadata = merge(var.storage_containers[count.index].metadata, var.use_tags_default ? {
    "tf_name" = var.storage_containers[count.index].name
    "tf_type" = "storage-container"
  } : {})
}
