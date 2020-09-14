# Azure Data Services deployment using Terraform

## Description

Terraform-based deployment of the following Azure resources:

- Azure Service Bus (namespace, topic, subscription, auth.rules)
- Azure Data Lake Storage
- Azure Data Factory (w/Git or without)
- Azure Data Factory linked with Data Lake Storage
- Azure Data Factory Pipeline
- Azure DataBricks WorkSpace
- Azure EventHub (namespace, eventhub)
- Azure Functions 
- Azure Data Explorer (Kusto)
- Azure Analysis Server (backup-enabled)
- Azure Event Grid (domain)

## Content

- auth.tf - Azure ARM provider authentication and version settings
- main.tf - Main configuration file that describes desired Azure infrastructure
- terraform.tfvars - Variables values to control/change the deployment settings
- variables.tf - List of variables used in the configuration
- outputs.tf - Outputs some useful info at the end of deployment (URLs and etc.)

## Usage

Control the deployment size:

- Open the terraform.tfvars file
- Identify the "What Should Be Deployed?" section
- Use true/false to setup your configuration
- Check or change Azure service settings in the appropriate sections
- Run terraform init to get required Terraform providers
- Run terraform plan to initiate pre-deployment check
- Run terraform apply to start deployment
- (optional) terraform destroy to delete Azure resources

Tested with the latest terraform 0.13.2 and AzureRM provider 2.27.0:

Download the latest terraform: 
https://www.terraform.io/downloads.html

## Requirements

Azure Service Principal with Contributor rights or higher:

- subscription id
- client id
- tenant id
- principal secret

If Analysis Server is going to be deployed:

- valid Azure AD user(s) UPN(s) (will be AS admin(s))

## Result

![Azure Resources](https://rlevchenko.files.wordpress.com/2020/09/image-2.png?w=768)

![Terraform output](https://rlevchenko.files.wordpress.com/2020/09/image-3.png?w=768)
