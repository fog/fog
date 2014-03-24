#Examples for working with HP Cloud Networking Service
The HP Cloud provides networking support using two abstractions: a model layer and a request layer. Both layers are detailed below.

**Note:** The networking functionality works with HP Cloud version 13.5 but is not available in version 12.12.

The code samples on this page can be executed from within a Ruby console (IRB):

        irb

This page discusses the following topics:

* [Connecting to the Service](#connecting-to-the-service)

**Model Layer Examples**

* [Model Network Operations](#model-network-operations)
* [Model Subnet Operations](#model-subnet-operations)
* [Model Port Operations](#model-port-operations)
* [Model Router Operations](#model-router-operations)
* [Model Security Group Operations](#model-security-group-operations)
* [Model Security Group Rules](#model-security-group-rules-operations)
* [Model Floating IPs](#model-floating-ips-operations)

**Request Layer Examples**

* [Request Network Operations](#request-network-operations)
* [Request Subnet Operations](#request-subnet-operations)
* [Request Port Operations](#request-port-operations)
* [Request Router Operations](#request-router-operations)
* [Request Security Group Operations](#request-security-group-operations)
* [Request Security Group Rules Operations](#request-security-group-rules-operations)
* [Request Floating IPs Operations](#request-floating-ips-operations)

## Connecting to the Service

To connect to the HP Cloud Networking Service, follow these steps:

1. Enter IRB

        irb

2. Require the Fog library

        require 'fog'

3. Establish a connection to the HP Cloud Networking service

        conn = Fog::HP::Network.new(
               :hp_access_key  => "<your_ACCESS_KEY>",
               :hp_secret_key => "<your_SECRET_KEY>",
               :hp_auth_uri   => "<IDENTITY_ENDPOINT_URL>",
               :hp_tenant_id => "<your_TENANT_ID>",
               :hp_avl_zone => "<your_AVAILABILITY_ZONE>",
               <other optional parameters>
               )

**Note**: You must use the `:hp_access_key` parameter rather than the now-deprecated  `:hp_account_id` parameter you might have used in previous Ruby Fog versions.

You can find the values the access key, secret key, and other values by clicking the [`API Keys`](https://console.hpcloud.com/account/api_keys) button in the [Console Dashboard](https://console.hpcloud.com/dashboard).

## Model Network Operations

1. List networks:

        conn.networks

2. List network using a filter:

        conn.networks.all({"router:external"=>true})

3. Obtain a network by ID:

        conn.networks.get("<network_id>")

4. Create a network:

        conn.networks.create(:name => "My Slick Network")

5. Delete a network:

        conn.networks.get("<network_id>").destroy

## Model Subnet Operations

1. List subnets:

        conn.subnets

2. List subnets using a filter:

        conn.subnets.all({:gateway_ip => "12.0.0.1"})

3. Create a subnet:

        conn.subnets.create(
                :network_id => "<network_id>",
                :cidr => "12.0.3.0/24",
                :ip_version => 4,
                :name => "My Subnet Model 1"
                )

4. Obtain a subnet by ID:

        conn.subnets.get("<subnet_id>")

5. Assign a DNS server to a subnet:

        subnet = conn.subnets.get("<subnet_id>")
        subnet.dns_nameservers = ["dns_ip"]
        subnet.save

6. Delete a subnet:

        conn.subnets.get("<subnet_id>").destroy

## Model Port Operations

1. List ports:

        conn.ports

2. List ports using a filter:

        conn.ports.all({:mac_address => "<mac_address>"})


3. Obtain a port by ID:

        conn.ports.get("<port_id>")

4. Create a port:

        conn.ports.create(
                :name => "Port Model 1",
                :network_id => "<network_id>"
                )

5. Delete a port:

        conn.ports.get("<port_id>").destroy

## Model Router Operations

1. List routers:

        conn.routers

2. List routers using a filter:

        conn.routers.all({:name => "Router 1"})

3. Obtain a router by ID:

        router = conn.routers.get("<router_id>")

4. Create a router:

        router = conn.routers.create(
                :name => "Router Model 1",
                :admin_state_up => true
                )

5. Add a router interface using a subnet:

        router.add_interface("<subnet_id>", nil)
        conn.ports        # If you look at the ports, note that a new port is auto. created, the device_id is assigned to the router id, and the device_owner is updated

6. Remove a router interface using a subnet:

        router.remove_interface("<subnet_id>", nil)
        # Removing the interface also deletes the auto-created port

7. Add a router interface using a port:

        # Add a router interface using the port you created
        network = router.add_interface(nil, "<port_id>")

        # Port is updated with device_id and device_owner
        conn.ports.get("<port_id>")

8. Remove a router interface using a port:

        router.remove_interface(nil, "<port_id>")
        # after removing the interface, the associated port is deleted

9. Delete a router:

        conn.routers.get("<router_id>").destroy

## Model Security Group Operations

1. List security groups:

        conn.security_groups

2. List security groups using a filter:

        conn.security_groups.all({:name => "My Security Group"})

3. Obtain a security group by ID:

        conn.security_groups.get("<SecurityGroup_id>")

4. Create a security group:

        conn.security_groups.create(
                :name => 'MySecurityGroup',
                :description => 'my security group description'
        )
**Note:** Two security group rules are created by default for every new security group that is created: one 'ingress' and one 'egress' rule.

5. Delete a security group:

        conn.security_groups.get("<SecurityGroup_id>").destroy

## Model Security Group Rules Operations

1. List security group rules:

        conn.security_group_rules

2. List security group rules using a filter:

        conn.security_group_rules.all({:direction => "ingress"})

3. Obtain a security group by ID:

        conn.security_group_rules.get("<SecurityGroupRule_id>")

4. Create a security group rule:

        conn.security_group_rules.create(
            :security_group_id => "<SecurityGroup_id>",
            :direction => 'ingress',
            :protocol => 'tcp',
            :port_range_min => 22,
            :port_range_max => 22,
            :remote_ip_prefix => '0.0.0.0/0'
        )

5. Delete a security group rule:

        conn.security_group_rules.get("<SecurityGroupRule_id>").destroy

## Model Floating IPs Operations

1. List floating IPs:

        conn.floating_ips

2. List floating IPs using a filter:

        conn.floating_ips.all("fixed_ip_address" => "<ip address>")

3. Obtain a floating IP by ID:

        conn.floating_ips.get("<FloatingIp_id>")

4. Create a floating IP:

        conn.floating_ips.create(
        	:floating_network_id => "<network_id>"
        )

5. Delete a floating IP:

        conn.floating_ips.get("<FloatingIp_id>").destroy


## Request Network Operations

1. List networks:

        conn.list_networks

2. List networks using a filter:

        conn.list_networks({"router:external" => true})

3. Obtain a network by ID:

        conn.get_network("<network_id>")

4. Create a network:

        conn.create_network({:name => "Network 1"})

5. Update a network:

        conn.update_network("<network_id>", {:name => "Network 1"})

6. Delete a network:

        conn.delete_network("<network_id>")

## Request Subnet Operations

1. List subnets:

        conn.list_subnets

2. List subnets using a filter:

        conn.list_subnets({"name"=>"My Subnet"})

3. Create a subnet:

        conn.create_subnet("<network_id>", "11.0.3.0/24", 4, {:name => "My Subnet"})

4. Obtain a subnet by ID:

        conn.get_subnet("<subnet_id>")

5. Update a subnet:

        conn.update_subnet("<subnet_id>", {:name => My Subnet Upd"})

6. Assign a DNS server to a subnet:

        conn.update_subnet("<subnet_id>", {:dns_nameservers => ["15.185.9.24"]})

7. Delete a subnet:

        conn.delete_subnet("<subnet_id>")

## Request Port Operations

1. List ports:

        conn.list_ports

2. List ports using a filter:

        conn.list_ports({"router_id" => "<router_id>"})

3. Obtain a port by ID:

        conn.get_port("<port_id>")

4. Create a port:

        conn.create_port("<network_id>", {:name => "myport"})

5. Update a port:

        conn.update_port("<port_id>", {:name => "My Port Upd"})

6. Delete a port:

        conn.delete_port("<port_id>")

## Request Router Operations

1. List routers:

        conn.list_routers

2. List routers using a filter:

        conn.list_routers({"name"=>"My Router"})

3. Obtain a router:

        conn.get_router("<router_id>")

4. Create a router:

        conn.create_router({:name => 'My Router'})

5. Update a router:

        conn.update_router("<router_id>" {:name => 'My Router Updates'})

6. Add a router interface using a subnet:

        conn.add_router_interface("<router_id>", "<subnet_id>")

7. Remove a router interface using a subnet:

        conn.remove_router_interface("<router_id>", "<subnet_id>")
        # Removes a port with no name using the subnet_id

8. Add a router interface using a port:

        conn.add_router_interface("<router_id>", nil, "<port_id>")

**Note:** Updates the router_id and device_owner for this port.

9. Remove a router interface using a port:

        conn.remove_router_interface("router_id", nil, "port_id")

10. Delete a router:

        conn.delete_router("<router_id>")

## Request Security Group Operations

1. List security groups:

        conn.list_security_groups

2. List security groups using a filter:

        conn.list_security_groups({:name => "My Security Group"})

3. Obtain a security group by ID:

        conn.get_security_group("<security_group_id>")

4. Create a security group:

        conn.create_security_group(
        :name => "My Security Group",
        :description => "What my security group does."
        )

5. Delete a security group:

        conn.delete_security_group("<security_group_id>")

## Request Security Group Rules Operations

1. List security group rules:

        conn.list_security_group_rules

2. List security group rules using a filter:

        conn.list_security_group_rules({:direction => 'egress'})

3. Obtain a security group rule by ID:

        conn.get_security_group_rule("<rule_id>")

4. Create a security group rule:

        conn.create_security_group_rule("<security_group_id>", 'ingress',{
                :remote_ip_prefix => ""0.0.0.0/0",
                :protocol => "tcp",
                :port_range_min => 22,
                :port_range_max => 22
                })

5. Delete a security group rule:

        conn.delete_security_group_rule("<rule_id>")

## Request Floating IPs Operations

1. List floating IPs:

        conn.list_floating_ips

2. List floating IPs using a filter:

        conn.list_floating_ips("fixed_ip_address" => "11.0.3.5")

3. Obtain a floating IP by ID:

        conn.get_floating_ip("<FloatingIp_id>")

4. Create a floating IP:

        conn.create_floating_ip("<FloatingIp_id>")

5. Delete a floating IP:

        conn.delete_floating_IP("<FloatingIp_id>")

---------
[Documentation Home](https://github.com/fog/fog/blob/master/lib/fog/hp/README.md) | [Examples](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)
