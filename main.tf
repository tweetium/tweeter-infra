provider "digitalocean" {
  version = "~> 1.6"
  token   = "${var.do_token}"
}

resource "digitalocean_volume" "main" {
  name   = "main"
  region = "sfo2"
  size   = 1
}

resource "digitalocean_droplet" "main" {
  name     = "main"
  image    = "ubuntu-18-04-x64"
  region   = "sfo2"
  size     = "s-1vcpu-1gb"
  ssh_keys = "${var.do_ssh_keys}"
}

resource "digitalocean_volume_attachment" "main" {
  droplet_id = "${digitalocean_droplet.main.id}"
  volume_id  = "${digitalocean_volume.main.id}"

  # Ensure that we can connect to the droplet via ssh before running ansible.
  provisioner "remote-exec" {
    inline = ["true"]
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${digitalocean_droplet.main.ipv4_address}"
      private_key = "${file("/root/.ssh/id_rsa")}"
    }
  }

  provisioner "local-exec" {
    # Extra comma is necessary for inventory (comma separated list)
    command = "ansible-playbook --inventory '${digitalocean_droplet.main.ipv4_address},' playbooks/main.yml"
  }
}
