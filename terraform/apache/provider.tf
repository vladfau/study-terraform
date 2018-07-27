variable "project_id" {}
variable "org_id" {}
variable "region" {}

provider "google" {
    region = "${var.region}"
    project = "${var.project_id}"
}
