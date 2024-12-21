locals {
  tags = {
    Name        = var.name
    Environment = "Dev"
    Cost_Center = "ENG"
    Account     = "Prod"
    Owner       = "Bereket"
    Team     = "TechOps"
    RM_Project_code = var.project_code

  }
}
