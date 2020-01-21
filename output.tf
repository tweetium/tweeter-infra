output "address" {
  value       = "${terraform.workspace}.tweeter.dev"
  description = "The address where the backend can be accessed on."
}

# Used until we get teleport / priviledged access setup.
output "nomad_ipv4_address" {
  value       = "${digitalocean_droplet.main.ipv4_address}:4646"
  description = "The ipv4 address where nomad can be accessed on."
}
