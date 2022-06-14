
  terraform {
    required_providers {
      alicloud = {
        source = "aliyun/alicloud"
        version = "1.99.0"
      }
    }
  }

  provider "alicloud" {
    # Configuration options
  }
module "ecs-instance" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "2.9.0"
}
