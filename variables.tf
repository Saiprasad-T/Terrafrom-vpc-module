variable "project" {      #for vpc
    type = string
}

variable "environment" {     #for vpc
    type = string
}

variable "cidr_block" {         #for vpc
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_tags" {              #for vpc
    type = map
    default = { }
}

variable "igw_tags" {               #for internet gatway
    type = map
    default = { }
}
# for  public subnet
variable "pub_sub_cidr" {
    type = list
    default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "pub_sub_tags" {
  type        = map
  default     = { }
}
# for  private subnet
variable "private_sub_cidr" {
    type = list
    default = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "private_sub_tags" {
  type        = map
  default     = { }
}
# for  database subnet
variable "database_sub_cidr" {
    type = list
    default = ["10.0.5.0/24","10.0.6.0/24"]
}

variable "database_sub_tags" {
  type        = map
  default     = { }
}
# for route table
variable "public_rtb_tags" {
  type        = map
  default     = { }
}

variable "private_rtb_tags" {
  type        = map
  default     = { }
}

variable "database_rtb_tags" {
  type        = map
  default     = { }
}
#variable for eip
variable "eip_nat_tags" {
  type        = map
  default     = { }
}

variable "nat_gtw_tags" {
  type        = map
  default     = { }
}

variable "is_peering_requried" {
    type = bool
    default = false
}

