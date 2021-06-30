provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_domain" "yourwebsite-com" {
  name = "yourwebsite.com"
}
