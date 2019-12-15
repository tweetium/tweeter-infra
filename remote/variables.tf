variable "do_token" {
  description = "The digital ocean personal access token used for provisioning / API access."
}

variable "do_ssh_key_name" {
  description = "The name that will be set for the mounted SSH key uploaded to DigitalOcean."
}

variable "cf_token" {
  description = "The Cloudflare access token used for API access."
}

# This is roughly equivalent to the domain you purchased:
# `tweeter.dev` in my case.
variable "cf_zone" {
  description = "The zone that will be used for said exposed subdomains^."
}
