# Overview

This project is for the purpose of creating Terraform modules that will be reused by specific Terraform base rigs. By breaking the modules out into their own repository, it makes it much easier to version tag the modules, thus allowing Terraform rigs and their environment modules to decide what version to support. This adds to the ability to enhance and grow new modules without adversely effecting independent rigs.

## foundation

This module is used to setup a base infrastructure that is made up of the following components:

* 1 - VPC
* 2 - Public Subnets
* 2 - Private Subnets
* 1 - Internet Gateway
* 1 - Public Route (Internet access)
* 2 - Elastic IPs (one for each NAT Gateway)
* 2 - NAT Gateways
* 2 - Private Route Tables
* 2 - Private Routes
* 2 - Public Route Table Associations
* 2 - Private Route Table Associations
* 1 - Security Group for Load Balancer
* 1 - Security Group Rule (ingress) for LB security group
* 1 - Load Balancer

## Usage

The simplest way to use these modules is to include them in a specific rig instance (riglet). For example, a specific riglet will usually have modules for each environment (integration, staging, production). Within each of those environment modules, will be submodules for (foundation, service, data-stores, apps, etc...). To include the foundation module from this project into the integration, staging and production for the specific riglet project, you would:

### 1. Setup module source

In the <riglet_project_root_dir>/integration/foundation/ directory, create a file called main.tf with the following base content:

```
module "foundation" {
  source = "git::git@github.com:buildit/terraform-modules.git//foundation"
}
```

### 2. Set the module version

Integration environments are usually used for CI/CD pipelines and you will usually but not always want the most recent version of this projects modules. So the above module import will be fine. But you may want a specific version of these modules for integration, even more likely you want a specific version for staging and for sure you want a specific version for production. To do that, you want to change the module source to pull in the specific version you need.

```
module "foundation" {
  source = "git::git@github.com:buildit/terraform-modules.git//foundation?ref=v0.0.1"
}
```

### 3. Override environment specific values

### 4. Import module dependency

Lastly, to get the module source into the actual riglet project, you need to pull it down into the riglet project. To do that, run the following command:

#### Using Terragrunt with Terraform

```
terragrunt get
```

#### Using Terraform without Terragrunt

```
terraform get
```
