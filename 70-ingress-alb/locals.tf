locals {
  acm_certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids   = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  ingress_alb_sg_id   = data.aws_ssm_parameter.ingress_alb_sg_id.value


  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}
