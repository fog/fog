#Networking (neutron)

This document explains how to get started using Networking with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

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

Next, create a connection to Rackspace's Networking API:

Using a US-based account:

	service = Fog::Rackspace::Networking.new({
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

By default `Fog::Rackspace::Networking` will authenticate against the US authentication endpoint and connect to the DFW region. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

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

The request abstraction maps directly to the [Networking API](http://docs.rackspace.com/networks/api/v2/cn-gettingstarted/content/ch_overview.html). It provides the most efficient interface to the Rackspace Networking

To see a list of requests supported by the service:

	service.requests

This returns:

	[:list_networks, :get_network, :create_network, :delete_network, :list_virtual_interfaces, :create_virtual_interface, :delete_virtual_interface]

#### Example Request

To request a list of flavors:

	response = service.list_networks

This returns in the following `Excon::Response`:

	<Excon::Response:0x0000010231acd8 @data={:body=>{"networks"=>[{"cidr"=>"192.168.0.0/24", "id"=>"08df79ae-b714-425c-ba25-91b0a8a78b9e", "label"=>"something"}, {"cidr"=>"192.168.0.0/24", "id"=>"eb3ed4b8-21d4-478e-9ae4-a35c0cc0437c", "label"=>"something"}, {"id"=>"00000000-0000-0000-0000-000000000000", "label"=>"public"}, {"id"=>"11111111-1111-1111-1111-111111111111", "label"=>"private"}]}, :headers=>{"Content-Type"=>"application/json", "Via"=>"1.1 Repose (Repose/2.12)", "Content-Length"=>"341", "Date"=>"Thu, 23 Oct 2014 20:53:41 GMT", "x-compute-request-id"=>"req-d34ab53c-45ed-433f-8a9d-b3341896b7e5", "Server"=>"Jetty(8.0.y.z-SNAPSHOT)"}, :status=>200, :remote_ip=>"162.209.116.128", :local_port=>60153, :local_address=>"192.168.1.65"}, @body="{\"networks\": [{\"cidr\": \"192.168.0.0/24\", \"id\": \"08df79ae-b714-425c-ba25-91b0a8a78b9e\", \"label\": \"something\"}, {\"cidr\": \"192.168.0.0/24\", \"id\": \"eb3ed4b8-21d4-478e-9ae4-a35c0cc0437c\", \"label\": \"something\"}, {\"id\": \"00000000-0000-0000-0000-000000000000\", \"label\": \"public\"}, {\"id\": \"11111111-1111-1111-1111-111111111111\", \"label\": \"private\"}]}", @headers={"Content-Type"=>"application/json", "Via"=>"1.1 Repose (Repose/2.12)", "Content-Length"=>"341", "Date"=>"Thu, 23 Oct 2014 20:53:41 GMT", "x-compute-request-id"=>"req-d34ab53c-45ed-433f-8a9d-b3341896b7e5", "Server"=>"Jetty(8.0.y.z-SNAPSHOT)"}, @status=200, @remote_ip="162.209.116.128", @local_port=60153, @local_address="192.168.1.65">

To view the status of the response:

	response.status

**Note**: Fog is aware of valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response body:

	response.body

This will return:

	{"networks"=>[{"cidr"=>"192.168.0.0/24", "id"=>"08df79ae-b714-425c-ba25-91b0a8a78b9e", "label"=>"something"}, {"cidr"=>"192.168.0.0/24", "id"=>"eb3ed4b8-21d4-478e-9ae4-a35c0cc0437c", "label"=>"something"}, {"id"=>"00000000-0000-0000-0000-000000000000", "label"=>"public"}, {"id"=>"11111111-1111-1111-1111-111111111111", "label"=>"private"}]}

To learn more about Networking request methods refer to [rdoc](http://www.rubydoc.info/gems/fog/Fog/Rackspace/Networking/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

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

This returns a collection of `Fog::Rackspace::Networking::Network` models:

 	<Fog::Rackspace::Networking::Networks
    [
      <Fog::Rackspace::Networking::Network
        id="08df79ae-b714-425c-ba25-91b0a8a78b9e",
        label="something",
        cidr="192.168.0.0/24"
      >,
      <Fog::Rackspace::Networking::Network
        id="eb3ed4b8-21d4-478e-9ae4-a35c0cc0437c",
        label="something",
        cidr="192.168.0.0/24"
      >,
      <Fog::Rackspace::Networking::Network
        id="00000000-0000-0000-0000-000000000000",
        label="public",
        cidr=nil
      >,
      <Fog::Rackspace::Networking::Network
        id="11111111-1111-1111-1111-111111111111",
        label="private",
        cidr=nil
      >
    ]
  >

## Create Network

Create a network:

 	service.networks.create(label: "new_network", cidr: "192.168.0.0/24")


## Get Network

To retrieve individual network:

	service.networks.get "8a3a9f96-b997-46fd-b7a8-a9e740796ffd"

This returns an `Fog::Rackspace::Networking::Network` instance:

    <Fog::Rackspace::Networking::Network
    id="08df79ae-b714-425c-ba25-91b0a8a78b9e",
    label="new_network",
    cidr="192.168.0.0/24"
  >

## Delete Network

To delete a network:

    network.destroy

**Note**: The network is not immediately destroyed, but it does occur shortly there after.

## List Virtual Interfaces

To retrieve a list of available virtual interfaces:

	service.virtual_interfaces.all(server: <server obj, or server id>)

This returns a collection of `Fog::Rackspace::Networking::VirtualInterface` models:

 	<Fog::Rackspace::Networking::VirtualInterfaces
    [
      <Fog::Rackspace::Networking::VirtualInterface
        id="f063815f-e576-450e-92bd-ff3aeeeb11e0",
        mac_address="BC:76:4E:20:A9:16",
        ip_addresses=[{"network_id"=>"11111111-1111-1111-1111-111111111111", "network_label"=>"private", "address"=>"10.176.12.249"}]
      >,
      <Fog::Rackspace::Networking::VirtualInterface
        id="f8196e20-788b-4447-80a5-32ca8fc9622f",
        mac_address="BC:76:4E:20:A8:56",
        ip_addresses=[{"network_id"=>"08df79ae-b714-425c-ba25-91b0a8a78b9e", "network_label"=>"new_network", "address"=>"192.168.0.1"}]
      >
    ]
  >

## Create Virtual Interface

Create a virtual interface:

 	service.virtual_interfaces.create(network: <network_id>, server: <server_id>)

## Delete Virtual Interface

To delete a virtual interface:

 	vis = service.virtual_interfaces.all(server: <server obj, or server id>)
 	vis.first.destroy

**Note**: The virtual interface is not immediately destroyed, but it does occur shortly there after.

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

For general feedback and support requests, send an email to: <sdk-support@rackspace.com>.

