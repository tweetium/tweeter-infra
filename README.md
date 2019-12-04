# tweeter-infra

### Pre-requisites
Requires a `secrets.auto.tfvars` file located in this directory with:
```
# Place your digital ocean API personal access token here.
do_token = "XXXXXXXXX"
# Place your digital ocean ssh key ids here so they are added to the machines.
do_ssh_keys = [XXXXXXX, XXXXXXX]
```

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

## Working with the Local environment
We manage the local environment via docker-compose, therefore you should not be inside
the docker container which you would use for working with other environments.

All you need to do is cd in the `local` folder and docker-compose up.
```
cd local
docker-compose up -d
```

### Updating the image (pulling `latest`)
To get the latest version pushed to DockerHub, use:
```
docker-compose pull
```

Or, if you want to use a custom version on DockerHub or even in your local images, you can change the tag in the docker-compose.yml file directly.

## Working with the Remote environment
First, cd into the `remote` folder and initialize terraform:
```
cd remote
terraform init
```

### Using workspaces
We use workspaces to manage separate versions of the application deployed to the remote backend. To start with, you can create your own personal workspace:
```
# Use your own name here
terraform workspace new [darren]
```

### Special workspaces
We currently have one special workspace named `production`. Running changes
on this workspace means changing the application exposed for the public.

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
