variable "ssh_key_name" {
    default = "awssa-demo"
}

variable "vpc_id" {
    default = "VPC_NAME"
}

variable "internal_subnet_id" {
    default = "SUBNET_NAME"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "base_ami" {
    default = "AMI_NAME"
}

variable "tagName" {
    default ="awssa-demo"
}

variable "server_count" {
    default = 1
}
