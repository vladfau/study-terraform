variable "project_id" {}
variable "org_id" {}
variable "region" {}

provider "google" {
    region = "${var.region}"
    project = "${var.project_id}"
}

// networks
data "google_compute_zones" "west-zones" {}

resource "google_compute_network" "net1" {
    name = "net1"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "west-subnet" {
    name = "net1-${var.region}"
    ip_cidr_range = "192.168.0.0/24"
    region = "${var.region}"
    network = "${google_compute_network.net1.self_link}"
}

resource "google_compute_firewall" "allow-net1" {
    name = "primary-allow-net1"
    network = "${google_compute_network.net1.name}"

    allow {
        protocol = "icmp"
    }
    allow {
        protocol = "tcp"
        ports = [ "22" ]
    }

    source_ranges = [ "0.0.0.0/0" ]
}
resource "google_compute_firewall" "allow-80-net1-internally" {
    name = "allow-80-net1-internally"
    network = "${google_compute_network.net1.name}"

    allow {
        protocol = "tcp"
        ports = [ "80" ]
    }

   source_ranges = [ "${google_compute_subnetwork.west-subnet.ip_cidr_range}" ]
}
resource "google_compute_firewall" "allow-80-net1-for-hc" {
    name = "allow-80-net1-for-hc"
    network = "${google_compute_network.net1.name}"

    allow {
        protocol = "tcp"
        ports = [ "80" ]
    }

   source_ranges = [ "130.211.0.0/22", "35.191.0.0/16" ]
}

// instances
resource "google_compute_instance" "main" {
    count = "3"
    project = "${var.project_id}"
    zone = "${data.google_compute_zones.west-zones.names[0]}"
    name = "net1-${count.index}"
    machine_type = "f1-micro"
    tags = ["apache"]
    boot_disk {
        initialize_params {
            image = "ubuntu-1604-xenial-v20180627"
        }
    }
    network_interface {
        subnetwork = "${google_compute_subnetwork.west-subnet.name}"
        access_config {}
    }
}
resource "google_compute_instance" "jump-host" {
     count = 1
     project = "${var.project_id}"
     zone = "${data.google_compute_zones.west-zones.names[0]}"
     name = "jumphost-${count.index}"
     machine_type = "f1-micro"
     boot_disk {
        initialize_params {
            image = "ubuntu-1604-xenial-v20180627"
        }
     }
     network_interface {
       subnetwork = "${google_compute_subnetwork.west-subnet.name}"
       access_config {}
     }
}
// ig
resource "google_compute_instance_group" "apache-ig" {
    name = "apache-ig"
    zone = "${data.google_compute_zones.west-zones.names[0]}"
    instances = ["${google_compute_instance.main.*.self_link}"]
}

// hc
resource "google_compute_health_check" "apache-tcp-health-check" {
    name = "apache-tcp-health-check"
    tcp_health_check {
        port = "80"
    }
}

// ilb
resource "google_compute_region_backend_service" "apache-ilb" {
    name = "apache-ilb"
    health_checks = ["${google_compute_health_check.apache-tcp-health-check.self_link}"]
    region = "${var.region}"
    backend {
        group = "${google_compute_instance_group.apache-ig.self_link}"
    }
}

resource "google_compute_forwarding_rule" "apache-fw-rule" {
    name = "apache-fw-rule"
    load_balancing_scheme = "INTERNAL"
    ports = ["80"]
    network = "${google_compute_network.net1.self_link}"
    subnetwork = "${google_compute_subnetwork.west-subnet.self_link}"
    backend_service = "${google_compute_region_backend_service.apache-ilb.self_link}"
}
