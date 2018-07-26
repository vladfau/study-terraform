data "google_compute_subnetwork" "default-west-subnet" {
    name = "default"
    region = "${var.region}"
}

resource "google_compute_firewall" "allow-from-default" {
    name = "enable-from-default"
    network = "${google_compute_network.net1.name}"

    allow {
        protocol = "tcp"
        ports = [ "8484" ]
    }

    source_ranges = [ "${data.google_compute_subnetwork.default-west-subnet.ip_cidr_range}" ]
}

resource "google_compute_firewall" "primary-allow-net1" {
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

resource "google_compute_firewall" "service-port-internal" {
    name = "service-port-internal-net1"
    network = "${google_compute_network.net1.name}"

    allow {
        protocol = "tcp"
        ports = [ "1337", "8484" ]
    }

   source_ranges = [ "${google_compute_subnetwork.west-subnet.ip_cidr_range}" ]

}
