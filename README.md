# API Health Demo

The goal of this repository is to build a demo of the ASP.NET Core [Health Checks](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/health-checks) feature.  

This project is still in a very early development stage, as it is used to learn other things like provisioning Azure resources using Terraform and populating a CosmosDB using a Python script.  

The API, whose development has not started yet 😅, is supposed to expose data from [this dataset](https://public.opendatasoft.com/explore/dataset/fromagescsv-fromagescsv/information/?disjunctive.fromage) which contains the whole list of french cheeses 🧀🐓 and their localization.


## State of the project

Currently the Terraform part is almost finished, it creates the Web App, the Cosmos DB, and import some of the data using a Python script run by the Terraform plan.  

Here is a summary of what is done and what is next:  
✔ Resource creation with Terraform  
✔ Grant access to Cosmos DB to the API using TF  
✔ Run Python script to import data in Cosmos DB from TF  
✔ Import departments with Python script  
✔ Import cheeses with Python script  
❌ Define API routes  
❌ Build API to expose data  
❌ Write Health Checks  
❌ Add App Insights with Web Tests targeting Health Checks


## Getting started

Currently only the Terraform part of the project is testable. To get started with it, you'll need to perform the following steps:
- Install Terraform, see tutorial [here](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started)
- Optional if you want to use Terraform Cloud as I do, you need to configure the Terraform backend:
  - Create a `backend.tf` in the `eng/tf` folder. This file is git-ignored as it contains the organization and the workspace name of my Terraform Cloud account.
  - If you plan to use Terraform Cloud the content of the `backend.tf` file will look like this:
```hcl
terraform {
  backend "remote" {
    organization = "<YOUR ORGANIZATION NAME>"

    workspaces {
      name = "<YOU WORKSPACE NAME>"
    }
  }
}
```
- If you want Terraform to operate locally, there is no need to configure anything, the local backend will be used by default
- Run `terraform init`
- Run `terraform plan`
- Run `terraform apply` 
