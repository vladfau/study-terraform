data "google_compute_zones" "west-zones" {}
locals {
    machine_type = "f1-micro"
    image = "ubuntu-1604-xenial-v20180627"
}
resource "google_compute_instance" "net1-host" {
 count = "3"
 project = "${var.project_id}"
 zone = "${data.google_compute_zones.west-zones.names[0]}"
 name = "apache-net1-${count.index}"
 machine_type = "${local.machine_type}"
 tags = ["apache"]
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
data "google_compute_network" "default" {
    name = "default"
}

resource "google_compute_firewall" "allow-apache" {
    name = "enable-from-default"
    network = "${data.google_compute_network.default.name}"

    allow {
        protocol = "tcp"
        ports = [ "80" ]
    }

    source_ranges = [ "0.0.0.0/0" ]
}


