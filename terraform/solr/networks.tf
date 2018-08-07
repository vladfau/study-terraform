resource "google_compute_network" "solrdemo" {
    name = "solrdemo"
    auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "west-subnet" {
    name = "solrdemo-west"
    ip_cidr_range = "192.168.0.0/27"
    region = "us-west1"
    network = "${google_compute_network.solrdemo.name}"
}

resource "google_compute_subnetwork" "east-subnet" {
    name = "solrdemo-east"
    ip_cidr_range = "192.168.1.0/27"
    region = "us-east1"
    network = "${google_compute_network.solrdemo.name}"
}


