module "ingress_alb" {
  source   = "terraform-aws-modules/alb/aws"
  version  = "9.16.0"
  internal = false

  name                       = "${var.project_name}-${var.environment}-ingress-alb"
  vpc_id                     = local.vpc_id
  subnets                    = local.public_subnet_ids
  create_security_group      = false # I have security group ready to attach
  security_groups            = [local.ingress_alb_sg_id]
  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-ingress-alb"
    }
  )
}

# attach listener to alb

resource "aws_lb_listener" "ingress_alb" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.acm_certificate_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from ingress ALB using HTTPS</h1>"
      status_code  = "200"
    }
  }
}


# create r53 record for dns alb url
resource "aws_route53_record" "ingress_alb" {
  zone_id = var.zone_id
  # name    = "*.${var.zone_name}"
  # name    = "*.backend-dev.${var.zone_name}"
  name = "${var.environment}.${var.zone_name}" # for cdn we fixed the frontalb record name
  type = "A"

  alias {
    name                   = module.ingress_alb.dns_name #get dns name from terraform alb module
    zone_id                = module.ingress_alb.zone_id  # zone id of ALB created in aws
    evaluate_target_health = true
  }
}
