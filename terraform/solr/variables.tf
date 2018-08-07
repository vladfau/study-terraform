variable "project_id" {}
variable "org_id" {}
variable "region" {}

provider "google" {
    region = "${var.region}"
    project = "${var.project_id}"
}

data "google_compute_zones" "west-zones" {}
data "google_compute_zones" "east-zones" {
    region = "us-east1"
}
