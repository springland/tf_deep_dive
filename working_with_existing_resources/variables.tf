variable "vpc_cidr_block" {
    type = string
    description = "cidr block of vpc"
    
}

variable "public_subnet_cidr_blocks"{
    type = list(string)
    description = "public subnet cidr blocks"
    
}

variable "private_subnet_cidr_blocks"{
    type = list(string)
    description = " private subnet cidr blocks"
    
}


variable "subnet_count"{
    type = number
    description = " number of subnets"
    
}
