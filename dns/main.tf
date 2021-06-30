provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_domain" "ashikkhulal-com" {
  name = "ashikkhulal.com"
}
