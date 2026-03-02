variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_tags" {
    type = string
    default = { }
}