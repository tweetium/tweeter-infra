variable "ssh_key_name" {
  type = "string"
  description = "The name of the your SSH key, used for locating the file at `~/.ssh/[SSH_KEY_NAME]`."
  default = "id_rsa"
}

variable "do_token" {
  description = "The digital ocean personal access token used for provisioning / API access."
}

variable "do_ssh_key_name" {
  description = "The name that will be set for the mounted SSH key uploaded to DigitalOcean."
}

variable "cf_token" {
  description = "The Cloudflare access token used for API access."
}

# Requires a zone to exist in the Cloudflare account named `var.cf_zone`.
# This zone is not managed by terraform because we share it between workspaces.
#
# This is better than looking up the zone id by name via terraform, because it requires
# less permissions for the API token.
variable "cf_zone_id" {
  description = "The zone id for the domain managed by Cloudflare. Used for exposing new infrastructure via subdomains."
}
