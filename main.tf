
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
resource "alicloud_vpc" "vpc" {
  name       = "tf_test_foo"
  cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/21"
 availability_zone = "cn-hangzhou-i"
}

resource "alicloud_security_group" "default" {
  name = "default"
  vpc_id = alicloud_vpc.vpc.id
}

data "alicloud_images" "ubuntu" {
  most_recent = true
  name_regex  = "^ubuntu_18.*64"
}

module "ecs_cluster" {
  source  = "alibaba/ecs-instance/alicloud"

  number_of_instances = var.instance_num  

  name                        = "my-ecs-cluster"
  use_num_suffix              = true
  image_id                    = data.alicloud_images.ubuntu.ids.0
  instance_type               = "ecs.sn1ne.large"
  vswitch_id                  = "vsw-fhuqie"
  security_group_ids          = ["sg-12345678"]
  associate_public_ip_address = true
  internet_max_bandwidth_out  = 10

  key_name = "for-ecs-cluster"

  system_disk_category = "cloud_ssd"
  system_disk_size     = 50

  tags = {
    Created      = "Terraform"
    Environment = "dev"
  }
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

