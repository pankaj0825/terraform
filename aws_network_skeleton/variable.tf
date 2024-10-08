variable "region" {
  type = string
  default = "ap-south-1"
}

variable "igw" {
  type        = bool
  description = "This variable is used to create IGW"
  default = false
}

variable "public_subnet_rt" {
  type        = bool
  description = "This variable is used to create Public Route Table and Public Subnets"
  default = false
}

variable "private_subnet_rt" {
  type        = bool
  description = "This variable is used to create Private Route Table and Private Subnets"
  default = false
}

variable "nat" {
  type        = bool
  description = "This variable is used to create Nat Gateway"
  default = false
}

variable "internet-gw-tag" {
  type = string
  default = "dev-vpc-igw"
}

variable "public-rt" {
  type = object({
    cidr = string
    tags = map(string)
  })
  default = {
    cidr = "0.0.0.0/0"
    tags = {
      "name" = "dev-vpc-public-rt"
      "env" = "development"
    }
  }
}

variable "private-rt" {
  type = object({
    cidr = string
    tags = map(string)
  })
  default = {
    cidr = "172.31.0.0/16"
    tags = {
      "name" = "dev-vpc-private-rt"
      "env" = "development"
    }
  }
}

variable "vpc" {
  type = object({
    cidr_block = string
    tags = map(string)
  })
  default = {
    cidr_block = "172.31.0.0/16"
    tags = {
      "name" = "dev-vpc"
      "env" = "development"
    }
  }
}

variable "public-subnet" {
  type = object({
    availability_zone = list(string)
    cidr_block = list(string)
    tags = map(string)
  })
  default = {
    availability_zone = [ "ap-south-1a" ]
    cidr_block = [ "172.31.0.0/24" ]
    tags = {
      "name" = "dev-vpc-public"
      "env" = "development"
    }
  }
}

variable "private-subnet" {
  type = object({
    availability_zone = list(string)
    cidr_block = list(string)
    tags = map(string)
  })
  default = {
    availability_zone = ["ap-south-1b", "ap-south-1c"]
    cidr_block = [ "172.31.16.0/20", "172.31.32.0/20" ]
     tags = {
      "name" = "dev-vpc-private"
      "env" = "development"
    }
  }
}

variable "eip" {
  type = object({
    tags = map(string)
  })
  default = {
    tags = {
      "name" = "develop-eip"
      "env" = "development"
    }
  }
}

variable "natgateway" {
  type = object({
    tags = map(string) 
  })
  default = {
    tags = {
      "name" = "develop-nat"
      "env" = "development"
    }
  }
}
