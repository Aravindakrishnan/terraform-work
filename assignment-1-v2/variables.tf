variable "region_name" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type    = string
  default = "aravindakrishan_keypair"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "pubsubnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "privsubnet_cidr" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "DB_USERNAME" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}