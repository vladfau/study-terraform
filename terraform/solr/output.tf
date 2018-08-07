output "zk-hosts-east" {
    value = "${google_compute_instance.zk-east.*.network_interface.0.address}"
}
output "zk-hosts-west" {
    value = "${google_compute_instance.zk-west.*.network_interface.0.address}"
}

output "zk-ilb-west" {
    value = "${google_compute_forwarding_rule.zk-west-fw-rule.ip_address}"
}
output "zk-ilb-east" {
    value = "${google_compute_forwarding_rule.zk-east-fw-rule.ip_address}"
}

output "solr-hosts-east" {
    value = "${google_compute_instance.solr-east.*.network_interface.0.address}"
}
output "solr-hosts-west" {
    value = "${google_compute_instance.solr-west.*.network_interface.0.address}"
}


