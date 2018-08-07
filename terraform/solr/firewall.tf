resource "google_compute_firewall" "global-rules" {
    name = "solrdemo-global-rules"
    network = "${google_compute_network.solrdemo.name}"

    allow {
        protocol = "icmp"
    }
allow {
        protocol = "tcp"
        ports = [ "22" ]
    }

    source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_firewall" "internal-rules" {
    name = "solrdemo-internal-rules"
    network = "${google_compute_network.solrdemo.name}"

    allow {
        protocol = "udp"
        ports = ["2181", "2888", "3888"]
    }
    allow {
        protocol = "tcp"
        ports = ["2181", "2888", "3888"]
    }
   source_ranges = [ "${google_compute_subnetwork.west-subnet.ip_cidr_range}",
                     "${google_compute_subnetwork.east-subnet.ip_cidr_range}" ]
}

resource "google_compute_firewall" "allow-2181-for-hc" {
    name = "solrdemo-for-hc"
    network = "${google_compute_network.solrdemo.name}"

    allow {
        protocol = "tcp"
        ports = [ "2181" ]
    }

   source_ranges = [ "130.211.0.0/22", "35.191.0.0/16" ]
}

resource "google_compute_firewall" "solr-rules" {
    name = "solrdemo-solr-global-rules"
    network = "${google_compute_network.solrdemo.name}"

    allow {
        protocol = "tcp"
        ports = [ "8983" ]
    }

    source_ranges = [ "0.0.0.0/0" ]
}


