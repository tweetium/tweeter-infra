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

## Working with the Production environment
First, cd into the `production` folder and initialize terraform:
```
cd production
terraform init
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
