# tweeter-infra

### Pre-requisites
Requires a private / public key pair located at `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`.
You can generate your public key into a file via the command:
```
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
```

Requires a `secrets.auto.tfvars` file located in project directory populated with
values to be used via terraform. See `./variables.tf` for a full list and
description.

Also requires Docker installed, see: https://docs.docker.com/v17.09/engine/installation/.

All commands to interact with the infrastructure (except for spinning up the infrastructure
locally) require that you build and connect to the docker-compose configuration located
at the top-level of the project.
```
# Start the docker-compose environment
docker-compose up -d

# Access a bash TTY for the container
docker-compose exec tweeter-infra bash
```

## Provisioning the application
First, initialize terraform:
```
terraform init
```

### Using workspaces
We use workspaces to manage separate versions of the infrastructure being deployed. These different
'instances' of the infrastructure also allow us to deploy different versions of applications / services.
To start with, you can create your own personal workspace:
```
# Use your own name here
terraform workspace new [darren]
```

### Special workspaces
We currently have one special workspace named `production`. Running changes
on this workspace means changing the application exposed for the public.

### Importing resources for new workspaces
When you create a new workspace, you may run into errors when running `terraform apply`.
This is due to some resources being shared between workspaces. Unfortunately
the process to resolve this is manual.

You must import these resources into the terraform state. Please see comments on
the resource definition on how to get the identifier for importing the item.

Generally the syntax is:
```
terraform import [digitalocean_ssh_key.main] [XXXXXX]
```

### Provisioning
To provision the infrastructure, run:
```
terraform apply
```

The current infrastructure is static and does not do any dynamic updates to change the configuration. Therefore, the ips of the machines are not known outside of terraform state, which only provisions / configures the machine on creation.

To change the infrastructure, the current process is to destroy and re-create the infrastructure.

## Destroy
To destroy the infrastructure, run:
```
terraform destroy
```
