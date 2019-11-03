provider "digitalocean" {
  version = "~> 1.6"
  token   = var.do_token
}

resource "digitalocean_droplet" "main" {
  name     = "main"
  image    = "ubuntu-18-04-x64"
  region   = "sfo2"
  size     = "s-1vcpu-1gb"
  ssh_keys = var.do_ssh_keys

  provisioner "remote-exec" {
    inline = ["true"]
    connection {
      type = "ssh"
      user = "root"
      host = "${self.ipv4_address}"
      private_key = "${file("/root/.ssh/id_rsa")}"
    }
  }

  provisioner "local-exec" {
    # Extra comma is necessary for inventory (comma separated list)
    command = "ansible-playbook --inventory '${self.ipv4_address},' playbooks/main.yml"
  }
}
