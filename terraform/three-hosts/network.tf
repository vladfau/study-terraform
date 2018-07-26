data "google_compute_network" "default" {
    name = "default"
}

resource "google_compute_network" "net1" {
    name = "net1"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "west-subnet" {
    name = "net1-west"
    ip_cidr_range = "192.168.0.0/24"
    region = "${var.region}"
    network = "${google_compute_network.net1.self_link}"
}

resource "google_compute_network_peering" "defaultToNet1" {
    name = "default-to-net1"
    network = "${data.google_compute_network.default.self_link}"
    peer_network = "${google_compute_network.net1.self_link}"
}

resource "google_compute_network_peering" "net1ToDefault" {
    name = "net1-to-default"
    network = "${google_compute_network.net1.self_link}"
    peer_network = "${data.google_compute_network.default.self_link}"
}
