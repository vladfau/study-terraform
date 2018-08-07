locals {
    solr_image = "centos-7-v20180716"
    solr_machine_type = "n1-standard-1"
    solr_count_west = 2
    solr_count_east = 1
}

resource "google_compute_instance" "solr-west" {
    count = "${local.solr_count_west}"
    project = "${var.project_id}"
    zone = "${data.google_compute_zones.west-zones.names[0]}"
    name = "solrdemo-solr-west-${count.index + 1}"
    machine_type = "${local.solr_machine_type}"
    boot_disk {
        initialize_params {
            image = "${local.solr_image}"
        }
    }
    network_interface {
    subnetwork = "${google_compute_subnetwork.west-subnet.name}"
    access_config {
        }
    }
    metadata {
        ZK_LB =  "${google_compute_forwarding_rule.zk-west-fw-rule.ip_address}"
    }
    tags = [ "solr", "west" ]
}

resource "google_compute_instance" "solr-east" {
    count = "${local.solr_count_east}"
    project = "${var.project_id}"
    zone = "${data.google_compute_zones.east-zones.names[0]}"
    name = "solrdemo-solr-east-${count.index + 1}"
    machine_type = "${local.solr_machine_type}"
    boot_disk {
    initialize_params {
     image = "${local.solr_image}"
        }
    }
    network_interface {
    subnetwork = "${google_compute_subnetwork.east-subnet.name}"
    access_config {
        }
    }
    metadata {
        ZK_LB =  "${google_compute_forwarding_rule.zk-east-fw-rule.ip_address}"
    }
    tags = [ "solr", "east" ]
}


