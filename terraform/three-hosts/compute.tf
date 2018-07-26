data "google_compute_zones" "west-zones" {}
locals {
    machine_type = "f1-micro"
    image = "ubuntu-1604-xenial-v20180627"
}
resource "google_compute_instance" "default" {
 project = "${var.project_id}"
 zone = "${data.google_compute_zones.west-zones.names[0]}"
 name = "default"
 machine_type = "${local.machine_type}"
 boot_disk {
   initialize_params {
     image = "${local.image}"
   }
 }
 network_interface {
   network = "default"
   access_config {
   }
 }
}

resource "google_compute_instance" "net1-host" {
 count = "2"
 project = "${var.project_id}"
 zone = "${data.google_compute_zones.west-zones.names[0]}"
 name = "net1-${count.index == 0 ? "main" : "secondary"}"
 machine_type = "${local.machine_type}"
 boot_disk {
   initialize_params {
     image = "${local.image}"
   }
 }
 network_interface {
   subnetwork = "${google_compute_subnetwork.west-subnet.name}"
   access_config {
   }
 }
 metadata {
    instanceName = "net1-${count.index == 0 ? "main" : "secondary"}"
 }
 metadata_startup_script = "${file("startup.sh")}"
}
