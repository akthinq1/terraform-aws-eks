
module "bastion" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.bastion_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.bastion_sg_name}"
  sg_name = var.bastion_sg_name
  vpc_id  = local.vpc_id
}

# create sg rule for bastion host to allow for admins 
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

######################################################################


# creating security group for VPN 
module "vpn" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.vpn_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.vpn_sg_name}"
  sg_name = var.vpn_sg_name
  vpc_id  = local.vpc_id
}

# create sg rules for vpn with port numbers ssh-22, https-443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type        = "ingress"
  from_port   = 943
  to_port     = 943
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type        = "ingress"
  from_port   = 1194
  to_port     = 1194
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id

}

#####################################################################

# create security group for forntend alb
module "ingress_alb" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.ingress_alb_sg_desc
  sg_name        = var.ingress_alb_sg_name
  vpc_id         = local.vpc_id
}

# create security group rules for frontend alb or ingress alb

# frontend ALB https
resource "aws_security_group_rule" "ingress_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb.sg_id
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

module "eks_control_plane" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.eks_control_plane_sg_desc
  sg_name        = var.eks_control_plane_sg_name
  vpc_id         = local.vpc_id
}

resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks_node.sg_id
  security_group_id        = module.eks_control_plane.sg_id
}

resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.eks_control_plane.sg_id
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

module "eks_node" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.eks_node_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.vpn_sg_name}"
  sg_name = var.eks_node_sg_name
  vpc_id  = local.vpc_id
}

resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.eks_control_plane.sg_id
  security_group_id        = module.eks_node.sg_id
}

resource "aws_security_group_rule" "eks_node_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.eks_node.sg_id
}

resource "aws_security_group_rule" "eks_node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = module.vpn.sg_id
}
