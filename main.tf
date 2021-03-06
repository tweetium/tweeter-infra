provider "digitalocean" {
  version = "~> 1.6"
  token   = var.do_token
}

data "digitalocean_image" "main" {
  name = "main"
}

# This ssh key may exist if you are managing multiple workspaces. To import this value, you
# should use the API, see: https://developers.digitalocean.com/documentation/v2/#ssh-keys
resource "digitalocean_ssh_key" "main" {
  name       = var.do_ssh_key_name
  public_key = file("/root/.ssh/${var.ssh_key_name}.pub")
}

resource "digitalocean_droplet" "main" {
  name     = "${terraform.workspace}-main"
  image    = data.digitalocean_image.main.id
  region   = "sfo2"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.main.fingerprint]

  # Ensure that we can connect to the droplet via ssh before running ansible.
  provisioner "remote-exec" {
    inline = ["true"]
    connection {
      type  = "ssh"
      user  = "root"
      host  = digitalocean_droplet.main.ipv4_address
      agent = true
    }
  }

  provisioner "local-exec" {
    # Extra comma in inventory is necessary for inventory (comma separated list)
    # ansible_python_interpretor is necessary because of Ubuntu Xenial: https://github.com/ansible/ansible/issues/19605
    command = "ansible-playbook --inventory '${digitalocean_droplet.main.ipv4_address},' -e 'ansible_python_interpreter=/usr/bin/python3' --skip-tags installation ./playbooks/setup.yml"
  }
}

resource "digitalocean_project" "project" {
  name        = "${terraform.workspace}-tweeter"
  environment = "Development"
  resources   = [digitalocean_droplet.main.urn]
}

data "digitalocean_domain" "tweeter_dev" {
  name = "tweeter.dev"
}

resource "digitalocean_record" "main" {
  domain = data.digitalocean_domain.tweeter_dev.name
  type   = "A"
  name   = terraform.workspace
  value  = digitalocean_droplet.main.ipv4_address
}
