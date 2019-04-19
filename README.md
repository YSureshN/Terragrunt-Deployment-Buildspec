# Infrastructure

## Prerequisites

- Terraform
- Terragrunt

## Bootstrap

Terragrunt handles the creation of the backend if it doesn't already exist. This will be created **if necessary** when running the `init` command.

The infrastructure is managed via AWS CodePipeline, and the initial pipeline is created by creating the globals module.

You will be prompted to provide an OAuth token for Github via the command line for this step.

```
cd pipeline/
terraform plan
terraform apply
```

## Layout

* *pipeline/* - Module for infrastructure pipeline. This is ran manually to bootstrap the project.
* *environment* - The application environment.
