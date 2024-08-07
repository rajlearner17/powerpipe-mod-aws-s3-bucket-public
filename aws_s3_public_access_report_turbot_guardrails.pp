dashboard "turbot_guardrails_aws_s3_bucket_public_access_report" {

  title = "AWS S3 Bucket Public Access Report - Turbot Guardrails"

  container {

    card {
      query = query.s3_bucket_count
      width = 2
    }

    card {
      query = query.s3_bucket_public_policy_summary
      width = 2
    }

    card {
      query = query.s3_bucket_block_public_acls_disabled_count
      width = 2
    }

    card {
      query = query.s3_bucket_block_public_policy_disabled_count
      width = 2
    }

    card {
      query = query.s3_bucket_ignore_public_acls_disabled_count
      width = 2
    }

    card {
      query = query.s3_bucket_restrict_public_buckets_disabled_count
      width = 2
    }

  }

    container {

    card {
      width = 2
    }

    chart {
      title = "Public Bucket Policy"
      query = query.s3_bucket_public_policy_summary_chart
      type = "donut"
      width = 2
      
      series "value" {
        point "Public" {
          color = "alert"
      }
        point "Not public" {
          color = "ok"
        }
   
      }
    }

    chart {
      title = "Block Public ACLs"
      query = query.s3_bucket_block_public_acls_chart
      type  = "donut"
      width = 2
      
      series "value" {
        point "Disabled" {
          color = "alert"
        }
        point "Enabled" {
          color = "ok"
        }
      }
    }

    chart {
      title = "Block Public Policy"
      query = query.s3_bucket_block_public_policy_chart
      type  = "donut"
      width = 2
      
      series "value" {
        point "Disabled" {
          color = "alert"
        }
        point "Enabled" {
          color = "ok"
        }
      }
    }

    chart {
      title = "Ignore Public ACLs"
      query = query.s3_bucket_ignore_public_acls_chart
      type  = "donut"
      width = 2
      
      series "value" {
        point "Disabled" {
          color = "alert"
        }
        point "Enabled" {
          color = "ok"
        }
      }
    }

    chart {
      title = "Restrict Public Buckets"
      query = query.s3_bucket_restrict_public_buckets_chart
      type  = "donut"
      width = 2
      
      series "value" {
        point "Disabled" {
          color = "alert"
        }
        point "Enabled" {
          color = "ok"
        }
      }
    }

  }

  table {
    column "Account ID" {
      display = "none"
    }

    column "ARN" {
      display = "none"
    }

    column "Resource URL" {
      display = "none"
    }

    column "Name" {
      href = "{{.'Resource URL'}}"
    }

    query = query.s3_bucket_public_access_table
  }

}


## Card Queries ##

query "s3_bucket_count" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT
      COUNT(*) as "Buckets"
    FROM
      bucket_data
  EOQ
}


query "s3_bucket_public_policy_summary" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT 
      COUNT(*) as value, 
      'Has Public Bucket Policy' as label, 
      CASE 
        WHEN COUNT(*) = 0 THEN 'ok' 
        ELSE 'alert' 
      END as "type"
    FROM 
      bucket_data
    WHERE 
      "Bucket Policy Public" = 'Public'
  EOQ
}

query "s3_bucket_block_public_acls_disabled_count" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT
      COUNT(*) as value,
      'New Public ACLs Allowed' as label,
      CASE 
        WHEN COUNT(*) = 0 THEN 'ok' 
        ELSE 'alert' 
      END as "type"
    FROM
      bucket_data
    WHERE
      "Block Public ACLs" = 'Disabled'
  EOQ
}

query "s3_bucket_block_public_policy_disabled_count" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT
      COUNT(*) as value,
      'New Public Bucket Policies Allowed' as label,
      CASE 
        WHEN COUNT(*) = 0 THEN 'ok' 
        ELSE 'alert' 
      END as "type"
    FROM
      bucket_data
    WHERE
      "Block Public Policy" = 'Disabled'
  EOQ
}

query "s3_bucket_ignore_public_acls_disabled_count" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT
      COUNT(*) as value,
      'Public ACLs Not Ignored' as label,
      CASE 
        WHEN COUNT(*) = 0 THEN 'ok' 
        ELSE 'alert' 
      END as "type"
    FROM
      bucket_data
    WHERE
      "Ignore Public ACLs" = 'Disabled'
  EOQ
}

query "s3_bucket_restrict_public_buckets_disabled_count" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT
      COUNT(*) as value,
      'Public Bucket Policies Unrestricted' as label,
      CASE 
        WHEN COUNT(*) = 0 THEN 'ok' 
        ELSE 'alert' 
      END as "type"
    FROM
      bucket_data
    WHERE
      "Restrict Public Buckets" = 'Disabled'
  EOQ
}

## Chart queries ##

query "s3_bucket_public_policy_summary_chart" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT 
      "Bucket Policy Public" as label,
      COUNT(*) as value,
      CASE 
        WHEN "Bucket Policy Public" = 'Public' THEN 'alert' 
        ELSE 'ok' 
      END as type
    FROM 
      bucket_data
    GROUP BY 
      "Bucket Policy Public"
    ORDER BY
      "Bucket Policy Public" DESC
  EOQ
}

query "s3_bucket_block_public_acls_chart" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT 
      "Block Public ACLs" as label,
      COUNT(*) as value,
      CASE 
        WHEN "Block Public ACLs" = 'Disabled' THEN 'alert' 
        ELSE 'ok' 
      END as type
    FROM 
      bucket_data
    GROUP BY 
      "Block Public ACLs"
    ORDER BY
      "Block Public ACLs" DESC
  EOQ
}

query "s3_bucket_block_public_policy_chart" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT 
      "Block Public Policy" as label,
      COUNT(*) as value,
      CASE 
        WHEN "Block Public Policy" = 'Disabled' THEN 'alert' 
        ELSE 'ok' 
      END as type
    FROM 
      bucket_data
    GROUP BY 
      "Block Public Policy"
    ORDER BY
      "Block Public Policy" DESC
  EOQ
}

query "s3_bucket_ignore_public_acls_chart" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT 
      "Ignore Public ACLs" as label,
      COUNT(*) as value,
      CASE 
        WHEN "Ignore Public ACLs" = 'Disabled' THEN 'alert' 
        ELSE 'ok' 
      END as type
    FROM 
      bucket_data
    GROUP BY 
      "Ignore Public ACLs"
    ORDER BY
      "Ignore Public ACLs" DESC
  EOQ
}

query "s3_bucket_restrict_public_buckets_chart" {
  sql = <<-EOQ
    WITH bucket_data AS (
      ${query.s3_bucket_public_access_table.sql}
    )
    SELECT 
      "Restrict Public Buckets" as label,
      COUNT(*) as value,
      CASE 
        WHEN "Restrict Public Buckets" = 'Disabled' THEN 'alert' 
        ELSE 'ok' 
      END as type
    FROM 
      bucket_data
    GROUP BY 
      "Restrict Public Buckets"
    ORDER BY
      "Restrict Public Buckets" DESC
  EOQ
}


## Table query ##

query "s3_bucket_public_access_table" {
  sql = <<-EOQ
  select
    title as "Name",
    case when data -> 'PolicyStatus' ->> 'IsPublic' = 'false' then 'Not public' else 'Public' end as "Bucket Policy Public",
    case when data -> 'PublicAccessBlock' ->> 'BlockPublicAcls' = 'true' then 'Enabled' else 'Disabled' end as "Block Public ACLs",
    case when data -> 'PublicAccessBlock' ->> 'BlockPublicPolicy' = 'true' then 'Enabled' else 'Disabled' end as "Block Public Policy",
    case when data -> 'PublicAccessBlock' ->> 'IgnorePublicAcls' = 'true' then 'Enabled' else 'Disabled' end as "Ignore Public ACLs",
    case when data -> 'PublicAccessBlock' ->> 'RestrictPublicBuckets' = 'true' then 'Enabled' else 'Disabled' end as "Restrict Public Buckets",
    metadata -> 'aws' ->> 'accountId' as "Account ID",
    metadata -> 'aws' ->> 'regionName' "Region",
    akas ->> 0 as "ARN",
    COALESCE(substring(metadata ->> 'createdBy' from '/([^/]+@[^/]+)-[^"]*$'), 'Unknown identity') as "Creator",
    workspace || '/apollo/resources/' || id as "Resource URL"
  from
    guardrails_resource
  where
    filter = 'resourceTypeId:tmod:@turbot/aws-s3#/resource/types/bucket'
  ORDER BY
    "Name" ASC
    EOQ
  }

