provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.access_id
  spaces_secret_key = var.secret_key
}

data "digitalocean_ssh_key" "demo" {
  name = "demo"
}

module "common" {
  source         = "../../common"
  region         = "sfo1"
  env            = "staging"
  instance-size  = "s-2vcpu-2gb"
  instance-count = 5
  db-size        = "db-s-4vcpu-8gb"
  db-nodes       = 3
  spaces-region  = "sfo1"
  redis-size     = "db-s-4vcpu-8gb"
  redis-nodes    = 2
  ssh-keys = [
  data.digitalocean_ssh_key.demo.id]
  domain = "uat.yourwebsite.com"
}
