provider "aws" {
  access_key = "AKIAZH76EJCHWUUDQYV5"
  secret_key = "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"
  region     = "ap-south-1"
}

data "aws_iam_role" "AWSServiceRoleForAmazonEMRServerless" {
  name = "AWSServiceRoleForAmazonEMRServerless"
}
resource "aws_emr_studio" "uws-emrserverless-studio" {
    auth_mode   = "IAM"
    default_s3_location  = "s3://khizer-emr/emr/"
    engine_security_group_id = "sg-0e1990bee4e65356f"
    name = "uws-emrserverless-studio"
    service_role = data.aws_iam_role.AWSServiceRoleForAmazonEMRServerless.arn
    subnet_ids = ["subnet-d8ecbfb0", "subnet-525ede1e"]
    vpc_id = "vpc-105d6878"
    workspace_security_group_id = "sg-0970e3e1591fb551d"
}

resource "aws_emrserverless_application" "click_log_loggregator_emr_serverless" {
   name = "uws-testing-application"
   release_label = "emr-6.9.0"
   type = "spark"


   initial_capacity {
    initial_capacity_type = "Driver"

    initial_capacity_config {
        worker_count = 1
        worker_configuration {
        cpu    = "4 vCPU"
        memory = "20 GB"
          }
      }
  }

 initial_capacity {
 initial_capacity_type = "Executor"

    initial_capacity_config {
        worker_count = 3
        worker_configuration {
        cpu  = "4 vCPU"
        memory = "20 GB"
         }
      }
  }


  maximum_capacity {
    cpu  = "2000 vCPU"
    memory = "10000 GB"
  }
  tags = {
    application-name = "uws"
    environment-type = "non-prod"
   }
}
