module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = "jlipinski-petclinic"
  repository_type = "private"
  # force delete even if images in repo
  repository_force_delete = true

  create_lifecycle_policy           = false
  repository_read_write_access_arns = [aws_iam_role.jenkins-worker.arn]
  repository_image_scan_on_push     = true
  repository_image_tag_mutability   = "MUTABLE"
}

module "ecr-url" {
  # store ECR URL in Parameter Store for easy retrieval (i.e. from Jenkins job)
  source  = "terraform-aws-modules/ssm-parameter/aws"
  version = "1.1.0"

  name  = "/jlipinski/ecr_registry_url"
  value = module.ecr.repository_url

  description = "ECR repository URL for petclinic app image - jlipinski"

  tags = {
    Name = "ecr_registry_url"
  }
}