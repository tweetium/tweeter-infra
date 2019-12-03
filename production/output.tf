output "main_ip_addr" {
  value = digitalocean_droplet.main.ipv4_address
  # TODO: don't expose this and instead map subdomain for a managed domain.
  description = "The ip where the backend can be accessed on."
}
