variable "region" {
    type = string
    default = "ap-south-1"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "public_ip" {
    type = bool
    default = true
}

variable "key_name" {
    type = string
    default = "mykey"
}

variable "instance_name" {
    type = string
    default = "HelloWorld"
}

variable "provisioner" {
    type = bool
    default = false
}

variable "path_pem_file" {
    type = string
    default = "\\/Users/pankaj/Downloads/mykey.pem"
}

variable "sg_name" {
    type = string
    default = "port22and80"
}

variable "sg_ing_ports" {
    type = list(number)
    default = [22, 80]
}

variable "sg_egress_ports" {
    type = list(number)
    default = [0]      
}