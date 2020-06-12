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