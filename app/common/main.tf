locals {
  name = "${var.env}-demo-project"
}

resource "digitalocean_vpc" "vpc" {
  name   = "${local.name}-network"
  region = var.region
}

resource "digitalocean_tag" "app" {
  name = "${local.name}-app"
}

resource "digitalocean_droplet" "app" {
  image      = "ubuntu-18-04-x64"
  count      = var.instance-count
  name       = "${local.name}-app-${count.index}"
  region     = var.region
  ssh_keys   = var.ssh-keys
  size       = var.instance-size
  monitoring = true
  vpc_uuid   = digitalocean_vpc.vpc.id
  tags       = [digitalocean_tag.app.id]
}

resource "digitalocean_database_cluster" "db" {
  name       = "${local.name}-db"
  engine     = "mysql"
  version    = "8"
  size       = var.db-size
  region     = var.region
  node_count = var.db-nodes
}

resource "digitalocean_database_firewall" "db-fw" {
  cluster_id = digitalocean_database_cluster.db.id
  rule {
    type  = "tag"
    value = digitalocean_tag.app.name
  }
}

resource "digitalocean_database_cluster" "redis" {
  name       = "${local.name}-redis"
  engine     = "redis"
  version    = "5"
  size       = var.redis-size
  region     = var.region
  node_count = var.redis-nodes
}

resource "digitalocean_database_firewall" "redis-fw" {
  cluster_id = digitalocean_database_cluster.redis.id
  rule {
    type  = "tag"
    value = digitalocean_tag.app.name
  }
}

resource "digitalocean_certificate" "certificate" {
  name    = "${local.name}-certificate"
  type    = "lets_encrypt"
  domains = [var.domain]
}

resource "digitalocean_loadbalancer" "lb" {
  name                   = "${local.name}-lb"
  region                 = var.region
  redirect_http_to_https = true
  droplet_tag            = "${local.name}-app"
  vpc_uuid               = digitalocean_vpc.vpc.id

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 80
    target_protocol = "http"

    certificate_id = digitalocean_certificate.certificate.id
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }
}

resource "digitalocean_firewall" "app" {
  name = "${local.name}-app-fw"

  tags = ["${local.name}-app"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "80"
    source_load_balancer_uids = [digitalocean_loadbalancer.lb.id]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_spaces_bucket" "spaces" {
  name   = "${local.name}-space"
  region = var.spaces-region
}
