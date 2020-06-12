output "address" {
  value       = "${terraform.workspace}.tweeter.dev"
  description = "The address where the backend can be accessed on."
}

# Used until we get teleport / priviledged access setup.
output "nomad_ipv4_address" {
  value       = "http://${digitalocean_droplet.main.ipv4_address}:4646"
  description = "The ipv4 address where nomad can be accessed on."
}

output "ansible_helper" {
  value       = "ansible-playbook -i '${digitalocean_droplet.main.ipv4_address},' -e 'ansible_python_interpreter=/usr/bin/python3'"
  description = "A helper for running playbooks on the main droplet"
}
