variable "az-1" {
  default = "us-east-1a"
}

variable "az-2" {
    default = "us-east-1b"
}

variable "CIDR_anywhere" {
  default = "0.0.0.0/0"
}

variable "ami" {
    default = "ami-05fa00d4c63e32376"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "linux_script" {
    default = "install_apache.sh"
}