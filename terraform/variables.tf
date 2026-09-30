variable "clusters" {
  description = "Clusters to create (names represent the cloud providers we're simulating)"
  type = map(object({
    cloud_name = string
  }))
  default = {
    "cloud-a" = {
      cloud_name = "aws"
    }
    "cloud-b" = {
      cloud_name = "azure"
    }
  }
}