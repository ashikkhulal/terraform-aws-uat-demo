provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "demo" {
  name       = "demo"
  public_key = file("${path.module}/files/demo.pub")
}
