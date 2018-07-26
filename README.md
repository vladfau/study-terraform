# study-terraform

Here I learn Terraform+Ansible and some other stuff from GD bench programm.

## terraform

### three-hosts

- create network net1
- create default-server on default network
- create peering net1 <-> default
- create server1 and server2 on net1 network
- create firewall rules to enable icmp + ssh on net1
- create firewall rules to enable tcp/8484 on net1 from default network
- create firewall rules to enable tcp/1337 on net1 from net1
- create startup scripts to bring up simplehttpserver on ports 8484 and 1337 and expose name of host via file



