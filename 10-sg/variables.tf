variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "bastion_sg_name" {
  default = "bastion-sg"
}

variable "bastion_sg_desc" {
  default = "create security group for bastion host"
}

variable "vpn_sg_name" {
  default = "vpn_node"
}

variable "vpn_sg_desc" {
  default = "create security group for vpn"
}

variable "ingress_alb_sg_name" {
  default = "ingress-alb-sg"
}

variable "ingress_alb_sg_desc" {
  default = "create security group for ingress-alb"
}

variable "eks_control_plane_sg_name" {
  default = "eks_control_plane"
}

variable "eks_control_plane_sg_desc" {
  default = "create security group for eks_control_plane"
}

variable "eks_node_sg_name" {
  default = "eks_node"
}

variable "eks_node_sg_desc" {
  default = "create security group for eks_node"
}

