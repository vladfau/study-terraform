
locals {
    image = "centos-7-v20180716"
    zk_machine_type = "g1-small"
    zk_count_west = 2
    zk_count_east = 1
}

resource "google_compute_instance" "zk-west" {
    count = "${local.zk_count_west}"
    project = "${var.project_id}"
    zone = "${data.google_compute_zones.west-zones.names[0]}"
    name = "solrdemo-zk-west-${count.index + 1}"
    machine_type = "${local.zk_machine_type}"
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
    tags = [ "zk", "west" ]
}

resource "google_compute_instance" "zk-east" {
    count = "${local.zk_count_east}"
    project = "${var.project_id}"
    zone = "${data.google_compute_zones.east-zones.names[0]}"
    name = "solrdemo-zk-east-${count.index + 1}"
    machine_type = "${local.zk_machine_type}"
    boot_disk {
    initialize_params {
     image = "${local.image}"
        }
    }
    network_interface {
    subnetwork = "${google_compute_subnetwork.east-subnet.name}"
    access_config {
        }
    }
    metadata {
    }
    tags = [ "zk", "east" ]
}

// ig
resource "google_compute_instance_group" "zk-west-ig" {
    name = "zk-west-ig"
    zone = "${data.google_compute_zones.west-zones.names[0]}"
    instances = ["${google_compute_instance.zk-west.*.self_link}"]
}

resource "google_compute_instance_group" "zk-east-ig" {
    name = "zk-east-ig"
    zone = "${data.google_compute_zones.east-zones.names[0]}"
    instances = ["${google_compute_instance.zk-east.*.self_link}"]
}

// hc
resource "google_compute_health_check" "zk-hc" {
    name = "apache-tcp-health-check"
    tcp_health_check {
        port = "2181"
    }
}

// ilb
resource "google_compute_region_backend_service" "zk-west-ilb" {
    name = "zk-west-ilb"
    health_checks = ["${google_compute_health_check.zk-hc.self_link}"]
    region = "us-west1"
    backend {
        group = "${google_compute_instance_group.zk-west-ig.self_link}"
    }
}

resource "google_compute_region_backend_service" "zk-east-ilb" {
    name = "zk-east-ilb"
    health_checks = ["${google_compute_health_check.zk-hc.self_link}"]
    region = "us-east1"
    backend {
        group = "${google_compute_instance_group.zk-east-ig.self_link}"
    }
}

resource "google_compute_forwarding_rule" "zk-west-fw-rule" {
    name = "zk-west-fw-rule"
    load_balancing_scheme = "INTERNAL"
    ports = ["2181"]
    network = "${google_compute_network.solrdemo.self_link}"
    subnetwork = "${google_compute_subnetwork.west-subnet.self_link}"
    backend_service = "${google_compute_region_backend_service.zk-west-ilb.self_link}"
    region = "us-west1"
}

resource "google_compute_forwarding_rule" "zk-east-fw-rule" {
    name = "zk-east-fw-rule"
    load_balancing_scheme = "INTERNAL"
    ports = ["2181"]
    network = "${google_compute_network.solrdemo.self_link}"
    subnetwork = "${google_compute_subnetwork.east-subnet.self_link}"
    backend_service = "${google_compute_region_backend_service.zk-east-ilb.self_link}"
    region = "us-east1"
}
