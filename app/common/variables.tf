variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "spaces-region" {
  type = string
}

variable "instance-size" {
  type = string
}

variable "ssh-keys" {
  type = list(string)
}

variable "domain" {
  type = string
}

variable "instance-count" {
  type = number
}

variable "db-size" {
  type = string
}

variable "db-nodes" {
  type = number
}

variable "redis-size" {
  type = string
}

variable "redis-nodes" {
  type = number
}
