provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      Owner       = "Cathal Mullan"
      Contact     = "contact@cathal.dev"
      Repository  = "https://github.com/CathalMullan/terraform-aws"
      Environment = "prod"
    }
  }
}
