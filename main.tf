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
    inline = ["sudo dnf -y install python"]

    connection {
      type        = "ssh"
      user        = "fedora"
      private_key = "${file(var.ssh_key_private)}"
    }
  }
}
