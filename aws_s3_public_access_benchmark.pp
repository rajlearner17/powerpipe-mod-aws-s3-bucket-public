benchmark "aws_s3_bucket_public_benchmark" {
  title       = "AWS S3 Public Access Governance Benchmark"
  description = "Controls relevant to AWS S3 Buckets public accessibility."
  children = [
    benchmark.aws_s3_bucket_public_accessibility_guardrails
  ]
}

benchmark "aws_s3_bucket_public_accessibility_guardrails" {
  title = "Turbot Guardrails S3 Bucket Public Accessibility Controls"
  children = [
    control.guardrails_s3_public_access_block_account,
    control.guardrails_s3_public_access_block_bucket
  ]
}

control "guardrails_s3_public_access_block_account" {
  title       = "AWS > S3 > Account > Public Access Block control enabled"
  description = "Manage access to resources in the AWS Cloud by ensuring that AWS Simple Storage Service (AWS S3) buckets cannot be publicly accessed."
  sql = <<-EOQ
with
  control_data as (
    select
      resource_trunk_title,
      state,
      reason,
      resource_id
    from
      guardrails_control
    where
      filter = 'controlTypeId:tmod:@turbot/aws-s3#/control/types/accountLevelPublicAccessBlock'
  ),
  resource_data as (
    select
      id,
      title,
      parent_id
    from
      guardrails_resource
    where
      filter in (
        select
          'id:' || resource_id
        from
          control_data
      )
  ),
  parent_resource_data as (
    select
      id,
      metadata -> 'aws' ->> 'accountId' as account_id,
      title as parent_title
    from
      guardrails_resource
    where
      filter in (
        select
          'id:' || parent_id
        from
          resource_data
      )
  )
select
  prd.parent_title as "resource",
  case
    when cd.state = 'ok' then 'ok'
    else 'alarm'
  end as status,
  case
    when cd.state = 'ok' then prd.parent_title || ' is meeting this control.'
    else 'Control is in a ' || UPPER(cd.state) || ' state for ' || prd.parent_title || ' due to ' || cd.reason || '.'
  end as reason,
  prd.account_id
from
  control_data cd
  join resource_data rd on cd.resource_id = rd.id
  left join parent_resource_data prd on rd.parent_id = prd.id;
  EOQ
}

control "guardrails_s3_public_access_block_bucket" {
  title       = "AWS > S3 > Bucket > Public Access Block control enabled"
  description = "Manage access to resources in the AWS Cloud by ensuring that AWS Simple Storage Service (AWS S3) buckets cannot be publicly accessed."
  sql = <<-EOQ
  with
    control_data as (
      select
        resource_trunk_title,
        state,
        reason,
        resource_id
      from
        guardrails_control
      where
        filter = 'controlTypeId:tmod:@turbot/aws-s3#/control/types/bucketLevelPublicAccessBlock'
    ),
    resource_data as (
      select
        id,
        title,
        metadata -> 'aws' ->> 'accountId' as account_id,
        metadata -> 'aws' ->> 'regionName' as region
      from
        guardrails_resource
      where
        filter in (
          select
            'id:' || resource_id
          from
            control_data
        )
    )
  select
    rd.title as "resource",
    case
      when cd.state = 'ok' then 'ok'
      else 'alarm'
    end as status,
    case
      when cd.state = 'ok' then rd.title || ' is meeting this control.'
      else 'Control is in a ' || UPPER(cd.state) || ' state for ' || rd.title || ' due to ' || cd.reason || '.'
    end as reason,
    rd.region,
    rd.account_id
  from
    control_data cd
    join resource_data rd on cd.resource_id = rd.id;
  EOQ
}
