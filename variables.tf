variable "instance_num" {
  default = 3
  description = "3"
}

variable "instance_type" {
  default = "ecs.n2.small"
  description = "ecs.n2.small"
}
variable "private_ids" {
  default = ["172.16.0.10", "172.16.0.11", "172.16.0.12"]  
  description = "collection"
}

