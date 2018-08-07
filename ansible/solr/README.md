SOLR module
==========

Solr + standalone Zookeeper.

Expects RHEL-based target hosts. Uses dynamic GCE inventory

# ZK
## Expectations
- id of instance is assigned by eth0 IP address, taking two last octets. Probably not the best idea but works, leading zero is omitted

## Variables
Expected:
- ZK_HOSTS=192.168.1.2,192.168.1.3,192.168.0.4,192.168.0.2,192.168.0.3 - comma-separated list of IPs for other members of cluster
- ZK_VERSION=3.4.12 – version of ZK

