provider "digitalocean" {
  version = "~> 1.6"
  token   = "${var.do_token}"
}

resource "digitalocean_volume" "main" {
  name   = "main"
  region = "sfo2"
  size   = 1
}

resource "digitalocean_ssh_key" "main" {
  name       = "${var.do_ssh_key_name}"
  public_key = file("/root/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "main" {
  name     = "main"
  image    = "ubuntu-18-04-x64"
  region   = "sfo2"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ssh_key.main.fingerprint}"]
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
    # Extra comma in inventory is necessary for inventory (comma separated list)
    # ansible_python_interpretor is necessary because of Ubuntu Xenial: https://github.com/ansible/ansible/issues/19605
    command = "ansible-playbook --inventory '${digitalocean_droplet.main.ipv4_address},' -e 'ansible_python_interpreter=/usr/bin/python3' ../playbooks/main.yml"
  }
}

resource "digitalocean_project" "project" {
  name        = "tweeter-${terraform.workspace}"
  environment = "Development"
  resources   = [digitalocean_droplet.main.urn, digitalocean_volume.main.urn]
}
