module "vpc" {
  # vpc module
  source = "git::https://github.com/akthinq1/terraform-aws-vpc.git?ref=main"

  #   need inputs for above module

  project_name          = var.project_name
  environment           = var.environment
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  is_peering_required = true

}
