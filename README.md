# AWS S3 Bucket Public Access Configuration Mod

This sample mod demonstrates how to reuse, remix, and customize Powerpipe dashboards. It focuses on bringing together new and custom AWS S3 Bucket Public Access configuration details in a benchmark and dashboard example from AWS directly and Turbot Guardrails.

## Prerequisites

* Steampipe AWS plugin installed
* Steampipe Turbot Guardrails plugin installed
* Powerpipe AWS Insights mod installed
* Powerpipe AWS Compliance mod installed

## Installation

1. Download and install Powerpipe (https://powerpipe.io/downloads).

2. Install the Steampipe AWS plugin:
`steampipe plugin install aws`

3. Install the Steampipe Turbot Guardrails plugin:
`steampipe plugin install guardrails`

4. Clone this repository:
```
git clone https://github.com/your-repo/aws-s3-bucket-public-access-mod.git
cd aws-s3-bucket-public-access-mod
```

5. Install the mod dependencies:
`powerpipe mod install`

## Usage

1. Start the Steampipe service:
`steampipe service start`

2. Start the dashboard server:
`powerpipe server`

3. Open your web browser and visit `http://localhost:9033`

You can now explore the AWS S3 Bucket Public Access Configuration dashboards and run benchmarks.

## Integrating with Turbot Pipes

You can also use this sample in Turbot Pipes. To integrate:

1. Fork this repository to your own GitHub account.
2. Log in to your Turbot Pipes account.
3. Integrate your GitHub account to Pipes, follow the [GitHub Integration](https://turbot.com/pipes/docs/integrations/github) guide.
  * Navigate to "Integrations", click "New Integration" button
  * Select `GitHub`, click "Create Integration` button
  * Redirected to GitHub, select which GitHub account you want to integrate, and either select all repos or select the forked `powerpipe-mod-aws-s3-bucket-public` repo.
4. Add the custom mods to your workspace, follow the Installing a [Custom Mod from an Integration](https://turbot.com/pipes/docs/mods#installing-a-custom-mod-from-an-integration) guide.
  * Back in Turbot Pipes, go to the Workspace to install the mod
  * Navigate to "Settings", then "Mods", then click the "Install Mods" button.
  * Select Custom tag, then choose the GitHub account, and then the forked `powerpipe-mod-aws-s3-bucket-public` repo.
  * Select which Branch or version constraint.  Click "Install Mods" button. 

Once installed, your dashboards will be available in your Turbot Pipes workspace. You can schedule updates, manage access, and integrate with other data sources and dashboards within the Turbot Pipes platform.

## File Structure in this repo

* `mod.pp`: Base mod file with the overarching Title of the mod that will show in your dashboard list. It demonstrates how to build a dependency on the AWS Compliance and AWS Insights mods to incorporate their controls and queries.

* `aws_s3_public_access_benchmark.pp`: Custom benchmark example. The first section reuses existing AWS Compliance mod controls specific to S3 and public access. Controls are referenced with the prefix 'aws_compliance'.

* `aws_s3_public_access_report.pp`: A modified version of the report from the AWS Insights mod, adapted to fit our scope. Queries are referenced with the prefix 'aws_insights'.

* `aws_s3_public_access_report_guardrails.pp`: Fully customized version of the prior report, using Turbot Guardrails for information and adding donut charts as additional examples.

## Customization

This mod serves as an example of how you can customize and combine existing mods. Feel free to modify the queries, add new visualizations, or incorporate data from other sources to suit your specific needs.
