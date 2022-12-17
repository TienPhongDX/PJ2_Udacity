terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 4.16"
      }
  }
}
provider "aws" {
    region = "us-east-1"
}
# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity_T2"{
    ami = "ami-0b5eea76982371e91"
    instance_type = "t2.micro"
    count = 4
    subnet_id = "subnet-0262437155ffa1323"
    tags = {
        Name = "Udacity T2"
    }
}
# TODO: provision 2 m4.large EC2 instances named Udacity M4
 resource "aws_instance" "udacity_M4"{
     ami = "ami-0b5eea76982371e91"
     instance_type = "m4.large"
     count = 2
     subnet_id = "subnet-0262437155ffa1323"
     tags = {
         Name = "Udacity M4"
     }
 }