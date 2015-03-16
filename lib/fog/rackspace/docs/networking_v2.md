#NetworkingV2 (neutron)

This document explains how to get started using NetworkingV2 with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

## Starting irb console

Start by executing the following command:

	irb

Once `irb` has launched you need to require the Fog library.

If using Ruby 1.8.x execute:

	require 'rubygems'
	require 'fog'

If using Ruby 1.9.x execute:

	require 'fog'

## Create Service

Next, create a connection to Rackspace's NetworkingV2 API:

Using a US-based account:

	service = Fog::Rackspace::NetworkingV2.new({
  		:rackspace_username  => RACKSPACE_USER_NAME, # Your Rackspace Username
  		:rackspace_api_key	 => RACKSPACE_API,       # Your Rackspace API key
		:rackspace_region	 => :ord,                # Defaults to :dfw
	})

Using a UK-based account:

	service = Fog::Compute.new({
		:rackspace_username  => RACKSPACE_USER_NAME,        # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,              # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
		:rackspace_region    => :lon,
	})

To learn more about obtaining cloud credentials refer to the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

By default `Fog::Rackspace::NetworkingV2` will authenticate against the US authentication endpoint and connect to the DFW region. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

Alternative regions are specified using the key `:rackspace_region `. A list of regions available for Cloud Servers can be found by executing the following:

	identity_service = Fog::Identity({
		:provider            => 'Rackspace',                     # Rackspace Fog provider
		:rackspace_username  => RACKSPACE_USER_NAME,             # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,                   # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT # Not specified for US Cloud
	})

	identity_service.service_catalog.display_service_regions :cloudServersOpenStack

### Optional Connection Parameters

Fog supports passing additional connection parameters to its underlying HTTP library (Excon) using the `:connection_options` parameter.

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:connect_timeout</td>
		<td>Connection timeout (default: 60 seconds)</td>
	</tr>
	<tr>
		<td>:read_timeout</td>
		<td>Read timeout for connection (default: 60 seconds)</td>	</tr>
	<tr>
		<td>:write_timeout</td>
		<td>Write timeout for connection (default: 60 seconds)</td>
	</tr>
	<tr>
		<td>:proxy</td>
		<td>Proxy for HTTP and HTTPS connections</td>
	</tr>
	<tr>
		<td>:ssl_ca_path</td>
		<td>Path to SSL certificate authorities</td>
	</tr>
	<tr>
		<td>:ssl_ca_file</td>
		<td>SSL certificate authority file</td>
	</tr>
	<tr>
		<td>:ssl_verify_peer</td>
		<td>SSL verify peer (default: true)</td>
	</tr>
</table>


## Fog Abstractions

Fog provides both a **model** and **request** abstraction. The request abstraction provides the most efficient interface and the model abstraction wraps the request abstraction to provide a convenient `ActiveModel` like interface.

### Request Layer

The request abstraction maps directly to the [NetworkingV2 API](http://docs.rackspace.com/networks/api/v2/cn-devguide/content/ch_overview.html). It provides the most efficient interface to the Rackspace NetworkingV2

To see a list of requests supported by the service:

	service.requests

This returns:

  [:list_networks, :create_network, :show_network, :update_network, :delete_network, :list_subnets, :create_subnet, :show_subnet, :update_subnet, :delete_subnet, :list_ports, :create_port, :show_port, :update_port, :delete_port]

#### Example Request

To request a list of flavors:

	response = service.list_networks

This returns in the following `Excon::Response`:

	  #<Excon::Response:0x007fbce39798a0 @data={:body=>{"networks"=>[{"status"=>"ACTIVE", "subnets"=>["79a2a078-84bd-4ffd-8e68-67f7854bb772"], "name"=>"Testing", "admin_state_up"=>true, "tenant_id"=>"000000", "shared"=>false, "id"=>"eff4da21-e006-4468-b9ce-798eb2fed3e8"}]}, :headers=>{"Content-Type"=>"application/json; charset=UTF-8", "Via"=>"1.1 Repose (Repose/2.12)", "Content-Length"=>"218", "Date"=>"Wed, 17 Dec 2014 19:37:49 GMT", "Server"=>"Jetty(8.0.y.z-SNAPSHOT)"}, :status=>200, :reason_phrase=>"OK", :remote_ip=>"69.20.65.143", :local_port=>63382, :local_address=>"192.168.1.80"}, @body="{\"networks\": [{\"status\": \"ACTIVE\", \"subnets\": [\"79a2a078-84bd-4ffd-8e68-67f7854bb772\"], \"name\": \"Testing\", \"admin_state_up\": true, \"tenant_id\": \"000000\", \"shared\": false, \"id\": \"eff4da21-e006-4468-b9ce-798eb2fed3e8\"}]}", @headers={"Content-Type"=>"application/json; charset=UTF-8", "Via"=>"1.1 Repose (Repose/2.12)", "Content-Length"=>"218", "Date"=>"Wed, 17 Dec 2014 19:37:49 GMT", "Server"=>"Jetty(8.0.y.z-SNAPSHOT)"}, @status=200, @remote_ip="69.20.0.0", @local_port=63382, @local_address="192.168.1.80">

To view the status of the response:

	response.status

**Note**: Fog is aware of valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response body:

	response.body

This will return:

	  {"networks"=>[{"status"=>"ACTIVE", "subnets"=>["79a2a078-84bd-4ffd-8e68-67f7854bb772"], "name"=>"Testing", "admin_state_up"=>true, "tenant_id"=>"000000", "shared"=>false, "id"=>"eff4da21-e006-4468-b9ce-798eb2fed3e8"}]}

To learn more about NetworkingV2 request methods refer to [rdoc](http://www.rubydoc.info/gems/fog/Fog/Rackspace/NetworkingV2/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

### Model Layer

Fog models behave in a manner similar to `ActiveModel`. Models will generally respond to `create`, `save`,  `persisted?`, `destroy`, `reload` and `attributes` methods. Additionally, fog will automatically create attribute accessors.

Here is a summary of common model methods:

<table>
	<tr>
		<th>Method</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>create</td>
		<td>
			Accepts hash of attributes and creates object.<br>
			Note: creation is a non-blocking call and you will be required to wait for a valid state before using resulting object.
		</td>
	</tr>
	<tr>
		<td>save</td>
		<td>Saves object.<br>
		Note: not all objects support updating object.</td>
	</tr>
	<tr>
		<td>persisted?</td>
		<td>Returns true if the object has been persisted.</td>
	</tr>
	<tr>
		<td>destroy</td>
		<td>
			Destroys object.<br>
			Note: this is a non-blocking call and object deletion might not be instantaneous.
		</td>
	<tr>
		<td>reload</td>
		<td>Updates object with latest state from service.</td>
	<tr>
		<td>ready?</td>
		<td>Returns true if object is in a ready state and able to perform actions. This method will raise an exception if object is in an error state.</td>
	</tr>
	<tr>
		<td>attributes</td>
		<td>Returns a hash containing the list of model attributes and values.</td>
	</tr>
		<td>identity</td>
		<td>
			Returns the identity of the object.<br>
			Note: This might not always be equal to object.id.
		</td>
	</tr>
	<tr>
		<td>wait_for</td>
		<td>This method periodically reloads model and then yields to specified block until block returns true or a timeout occurs.</td>
	</tr>
</table>

The remainder of this document details the model abstraction.

## List Networks

To retrieve a list of available networks:

	service.networks

This returns a collection of `Fog::Rackspace::NetworkingV2::Network` models:

	  <Fog::Rackspace::NetworkingV2::Networks
	    [
	      <Fog::Rackspace::NetworkingV2::Network
	        id="eff4da21-e006-4468-b9ce-798eb2fed3e8",
	        admin_state_up=true,
	        label=nil,
	        name="Testing",
	        shared=false,
	        status="ACTIVE",
	        subnets=["79a2a078-84bd-4ffd-8e68-67f7854bb772"],
	        tenant_id="000000"
	      >
	    ]
	  >

## Create Network

Create a network:

	 	service.networks.create(label: "new_network", cidr: "192.168.0.0/24")

## Get Network

To retrieve individual network:

	  service.networks.get "eff4da21-e006-4468-b9ce-798eb2fed3e8"

This returns an `Fog::Rackspace::NetworkingV2::Network` instance:

	  <Fog::Rackspace::NetworkingV2::Network
	    id="eff4da21-e006-4468-b9ce-798eb2fed3e8",
	    admin_state_up=true,
	    label=nil,
	    name="Testing",
	    shared=false,
	    status="ACTIVE",
	    subnets=["79a2a078-84bd-4ffd-8e68-67f7854bb772"],
	    tenant_id="000000"
	  >

## Delete Network

To delete a network:

    network.destroy

**Note**: The network is not immediately destroyed, but it does occur shortly there after.


## List Subnets

To retrieve a list of available subnets:

	service.subnets

This returns a collection of `Fog::Rackspace::NetworkingV2::Subnet` models:

	  <Fog::Rackspace::NetworkingV2::Subnets
	    [
	      <Fog::Rackspace::NetworkingV2::Subnet
	        id="79a2a078-84bd-4ffd-8e68-67f7854bb772",
	        name="",
	        enable_dhcp=nil,
	        network_id="eff4da21-e006-4468-b9ce-798eb2fed3e8",
	        tenant_id="000000",
	        dns_nameservers=[],
	        allocation_pools=[{"start"=>"192.168.3.1", "end"=>"192.168.3.254"}],
	        host_routes=[],
	        ip_version=4,
	        gateway_ip=nil,
	        cidr="192.168.3.0/24"
	      >
	    ]
	  >

## Create Subnet

Create a subnet:

	  subnet = service.subnets.new({
	    :name       => "ANewsubnet",
	    :cidr       => "192.168.101.1/24",
	    :network_id => "79a2a078-84bd-4ffd-8e68-67f7854bb772",
	    :ip_version => "4"
	  }).save

## Get Subnet

To retrieve individual subnet:

	  service.subnets.get "79a2a078-84bd-4ffd-8e68-67f7854bb772"

This returns an `Fog::Rackspace::NetworkingV2::Subnet` instance:

	  <Fog::Rackspace::NetworkingV2::Subnet
	    id="79a2a078-84bd-4ffd-8e68-67f7854bb772",
	    name="",
	    enable_dhcp=nil,
	    network_id="eff4da21-e006-4468-b9ce-798eb2fed3e8",
	    tenant_id="000000",
	    dns_nameservers=[],
	    allocation_pools=[{"start"=>"192.168.3.1", "end"=>"192.168.3.254"}],
	    host_routes=[],
	    ip_version=4,
	    gateway_ip=nil,
	    cidr="192.168.3.0/24"
	  >

## Delete Subnet

To delete a subnet:

    subnet.destroy

**Note**: The subnet is not immediately destroyed, but it does occur shortly there after.


## List Ports

To retrieve a list of available ports:

	service.ports

This returns a collection of `Fog::Rackspace::NetworkingV2::Port` models:

	  <Fog::Rackspace::NetworkingV2::Ports
	    [
	      <Fog::Rackspace::NetworkingV2::Port
	        id="79a2a078-84bd-4ffd-8e68-67f7854bb772",
	        name="",
	        enable_dhcp=nil,
	        network_id="eff4da21-e006-4468-b9ce-798eb2fed3e8",
	        tenant_id="000000",
	        dns_nameservers=[],
	        allocation_pools=[{"start"=>"192.168.3.1", "end"=>"192.168.3.254"}],
	        host_routes=[],
	        ip_version=4,
	        gateway_ip=nil,
	        cidr="192.168.3.0/24"
	      >
	    ]
	  >

## Create Port

Create a port:

	  s.ports.new({name: "something", network_id: network.id}).save

	  <Fog::Rackspace::NetworkingV2::Ports
	    [
	      <Fog::Rackspace::NetworkingV2::Port
	        id="f90c5970-1bce-4403-82ee-7713854de7c7",
	        admin_state_up=true,
	        device_id="",
	        device_owner=nil,
	        fixed_ips=[{"subnet_id"=>"79a2a078-84bd-4ffd-8e68-67f7854bb772", "ip_address"=>"192.168.3.1"}],
	        mac_address="BC:76:4E:20:CB:0D",
	        name="something",
	        network_id="eff4da21-e006-4468-b9ce-798eb2fed3e8",
	        security_groups=[],
	        status="ACTIVE",
	        tenant_id="000000"
	      >
	    ]
	  >

## Get Port

To retrieve individual port:

  	service.ports.get "f90c5970-1bce-4403-82ee-7713854de7c7"

This returns an `Fog::Rackspace::NetworkingV2::Port` instance:

	  <Fog::Rackspace::NetworkingV2::Port
	    id="f90c5970-1bce-4403-82ee-7713854de7c7",
	    admin_state_up=true,
	    device_id="",
	    device_owner=nil,
	    fixed_ips=[{"subnet_id"=>"79a2a078-84bd-4ffd-8e68-67f7854bb772", "ip_address"=>"192.168.3.1"}],
	    mac_address="BC:76:4E:20:CB:0D",
	    name="something",
	    network_id="eff4da21-e006-4468-b9ce-798eb2fed3e8",
	    security_groups=[],
	    status="ACTIVE",
	    tenant_id="000000"
	  >

## Delete Port

To delete a port:

    port.destroy

**Note**: The port is not immediately destroyed, but it does occur shortly there after.




## Examples

Example code using Networking can be found [here](https://github.com/fog/fog/tree/master/lib/fog/rackspace/examples).

## Additional Resources

* [fog.io](http://fog.io/)
* [Fog rdoc](http://rubydoc.info/gems/fog/)
* [Fog Github repo](https://github.com/fog/fog)
* [Fog Github Issues](https://github.com/fog/fog/issues)
* [Excon Github repo](https://github.com/geemus/excon)
* [Rackspace Networking API](http://docs.rackspace.com/networking/api/v2/cs-devguide/content/ch_preface.html)

## Support and Feedback

Your feedback is appreciated! If you have specific issues with the **fog** SDK, you should file an [issue via Github](https://github.com/fog/fog/issues).

For general feedback and support requests, please visit: https://developer.rackspace.com/support.
