#Next Generation Cloud Servers™ (compute_v2)

This document explains how to get started using Next Generation Cloud Servers with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

**Note**: Fog also provides an interface to First Gen Cloud Servers™ (compute). The compute interface is deprecated and should only be used if you need to interact with our first generation cloud. Fog determines the appropriate interface based on the `:version` parameter. See [Create Service](#create-service) section for more information.

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

Next, create a connection to the Next Gen Cloud Servers:

Using a US-based account:

	service = Fog::Compute.new({
  		:provider            => 'Rackspace',         # Rackspace Fog provider
  		:rackspace_username  => RACKSPACE_USER_NAME, # Your Rackspace Username
  		:rackspace_api_key   => RACKSPACE_API,       # Your Rackspace API key
		:version             => :v2,                 # Use Next Gen Cloud Servers
		:rackspace_region    => :ord,                # Defaults to :dfw
		:connection_options  => {}                   # Optional
	})

Using a UK-based account:

	service = Fog::Compute.new({
		:provider            => 'Rackspace',                # Rackspace Fog provider
		:rackspace_username  => RACKSPACE_USER_NAME,        # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,              # Your Rackspace API key
		:version             => :v2,                        # Use Next Gen Cloud Servers
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
		:rackspace_region    => :lon,
		:connection_options  => {}                          # Optional
	})

To learn more about obtaining cloud credentials refer to the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

By default `Fog::Compute` will authenticate against the US authentication endpoint and connect to the DFW region. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

Alternative regions are specified using the key `:rackspace_region `. A list of regions available for Cloud Servers can be found by executing the following:

	identity_service = Fog::Identity({
		:provider            => 'Rackspace',                     # Rackspace Fog provider
		:rackspace_username  => RACKSPACE_USER_NAME,             # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,                   # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT # Not specified for US Cloud
	})

	identity_service.service_catalog.display_service_regions :cloudServersOpenStack

Rackspace Private Cloud installations can skip specifying a region and directly specify their custom service endpoints using the key `:rackspace_compute_url`.

**Note**: A`Fog::Compute` instance is needed for the desired region.

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

The request abstraction maps directly to the [Next Gen Cloud Servers API](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_preface.html). It provides the most efficient interface to the Rackspace Open Cloud.

To see a list of requests supported by the service:

	service.requests
	
This returns:

	:list_servers, :get_server, :create_server, :update_server, :delete_server, :change_server_password, :reboot_server, :rebuild_server, :resize_server, :confirm_resize_server, :revert_resize_server, :list_images, :get_image, :list_flavors, :get_flavor, :attach_volume, :get_attachment, :list_attachments, :delete_attachment, :get_vnc_console


#### Example Request

To request a list of flavors:

	response = service.list_flavors

This returns in the following `Excon::Response`:

	<Excon::Response:0x007fe4b2ea2f38 @body={"flavors"=>[{"id"=>"2", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/2", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/2", "rel"=>"bookmark"}], "name"=>"512MB Standard Instance"}, {"id"=>"3", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/3", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/3", "rel"=>"bookmark"}], "name"=>"1GB Standard Instance"}, {"id"=>"4", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/4", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/4", "rel"=>"bookmark"}], "name"=>"2GB Standard Instance"}, {"id"=>"5", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/5", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/5", "rel"=>"bookmark"}], "name"=>"4GB Standard Instance"}, {"id"=>"6", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/6", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/6", "rel"=>"bookmark"}], "name"=>"8GB Standard Instance"}, {"id"=>"7", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/7", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/7", "rel"=>"bookmark"}], "name"=>"15GB Standard Instance"}, {"id"=>"8", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/8", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/8", "rel"=>"bookmark"}], "name"=>"30GB Standard Instance"}]}, @headers={"Date"=>"Mon, 21 Jan 2013 16:14:45 GMT", "Content-Length"=>"1697", "Content-Type"=>"application/json", "X-Compute-Request-Id"=>"req-0a1e8532-19b3-4993-8b48-cf2d9efe078c", "Server"=>"Jetty(8.0.y.z-SNAPSHOT)"}, @status=200>

To view the status of the response:
	
	response.status
	
**Note**: Fog is aware of valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response body:

	response.body
	
This will return:

	{"flavors"=>[{"id"=>"2", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/2", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/2", "rel"=>"bookmark"}], "name"=>"512MB Standard Instance"}, {"id"=>"3", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/3", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/3", "rel"=>"bookmark"}], "name"=>"1GB Standard Instance"}, {"id"=>"4", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/4", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/4", "rel"=>"bookmark"}], "name"=>"2GB Standard Instance"}, {"id"=>"5", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/5", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/5", "rel"=>"bookmark"}], "name"=>"4GB Standard Instance"}, {"id"=>"6", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/6", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/6", "rel"=>"bookmark"}], "name"=>"8GB Standard Instance"}, {"id"=>"7", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/7", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/7", "rel"=>"bookmark"}], "name"=>"15GB Standard Instance"}, {"id"=>"8", "links"=>[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/flavors/8", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/flavors/8", "rel"=>"bookmark"}], "name"=>"30GB Standard Instance"}]}
	
	
To learn more about Compute request methods refer to [rdoc](http://rubydoc.info/gems/fog/Fog/Compute/Rackspace/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

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
	
## List Images

To retrieve a list of available images:

	service.images
	
This returns a collection of `Fog::Compute::RackspaceV2::Image` models:

	 <Fog::Compute::RackspaceV2::Images
      [
        <Fog::Compute::RackspaceV2::Image
          id="8a3a9f96-b997-46fd-b7a8-a9e740796ffd",
          name="Ubuntu 12.10 (Quantal Quetzal)",
          created=nil,
          updated=nil,
          state=nil,
          user_id=nil,
          tenant_id=nil,
          progress=nil,
          minDisk=nil,
          minRam=nil,
          metadata=nil,
          disk_config=nil,
          links=[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/images/8a3a9f96-b997-46fd-b7a8-a9e740796ffd", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/images/8a3a9f96-b997-46fd-b7a8-a9e740796ffd", "rel"=>"bookmark"}, {"href"=>"https://ord.images.api.rackspacecloud.com/772045/images/8a3a9f96-b997-46fd-b7a8-a9e740796ffd", "type"=>"application/vnd.openstack.image", "rel"=>"alternate"}]
        >,
        <Fog::Compute::RackspaceV2::Image
          id="992ba82c-083b-4eed-9c26-c54473686466",
          name="Windows Server 2012 + SharePoint Foundation 2013 with SQL Server 2012 Standard",
          created=nil,
          updated=nil,
          state=nil,
          user_id=nil,
          tenant_id=nil,
          progress=nil,
          minDisk=nil,
          minRam=nil,
          metadata=nil,
          disk_config=nil,
          links=[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/images/992ba82c-083b-4eed-9c26-c54473686466", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/images/992ba82c-083b-4eed-9c26-c54473686466", "rel"=>"bookmark"}, {"href"=>"https://ord.images.api.rackspacecloud.com/772045/images/992ba82c-083b-4eed-9c26-c54473686466", "type"=>"application/vnd.openstack.image", "rel"=>"alternate"}]
        >,
	…

## Get Image

To retrieve individual image:

	service.images.get "8a3a9f96-b997-46fd-b7a8-a9e740796ffd"
	
This returns an `Fog::Compute::RackspaceV2::Image` instance:

	 <Fog::Compute::RackspaceV2::Image
      id="8a3a9f96-b997-46fd-b7a8-a9e740796ffd",
      name="Ubuntu 12.10 (Quantal Quetzal)",
      created="2012-11-27T15:27:08Z",
      updated="2012-11-28T14:35:21Z",
      state="ACTIVE",
      user_id=nil,
      tenant_id=nil,
      progress=100,
      minDisk=10,
      minRam=512,
      metadata={"os_distro"=>"ubuntu", "com.rackspace__1__visible_core"=>"1", "com.rackspace__1__build_rackconnect"=>"1", "auto_disk_config"=>"True", "com.rackspace__1__options"=>"0", "image_type"=>"base", "org.openstack__1__os_version"=>"12.10", "os_version"=>"12.10", "rax_options"=>"0", "com.rackspace__1__visible_rackconnect"=>"1", "org.openstack__1__os_distro"=>"org.ubuntu", "com.rackspace__1__visible_managed"=>"1", "com.rackspace__1__build_core"=>"1", "arch"=>"x86-64", "os_type"=>"linux", "org.openstack__1__architecture"=>"x64", "com.rackspace__1__build_managed"=>"1"},
      disk_config="AUTO",
      links=[{"href"=>"https://ord.servers.api.rackspacecloud.com/v2/772045/images/8a3a9f96-b997-46fd-b7a8-a9e740796ffd", "rel"=>"self"}, {"href"=>"https://ord.servers.api.rackspacecloud.com/772045/images/8a3a9f96-b997-46fd-b7a8-a9e740796ffd", "rel"=>"bookmark"}, {"href"=>"https://ord.images.api.rackspacecloud.com/772045/images/8a3a9f96-b997-46fd-b7a8-a9e740796ffd", "type"=>"application/vnd.openstack.image", "rel"=>"alternate"}]
    >

## List Flavors

To retrieve a list of available flavors:

	service.flavors
	
This returns a collection of `Fog::Compute::RackspaceV2::Flavor` models:

	<Fog::Compute::RackspaceV2::Flavors
    [
      <Fog::Compute::RackspaceV2::Flavor
        id="2",
        name="512MB Standard Instance",
        ram=nil,
        disk=nil,
        vcpus=nil,
        links=[{"href"=>"https://dfw.servers.api.rackspacecloud.com/v2/772045/flavors/2", "rel"=>"self"}, {"href"=>"https://dfw.servers.api.rackspacecloud.com/772045/flavors/2", "rel"=>"bookmark"}]
      >,
      <Fog::Compute::RackspaceV2::Flavor
        id="3",
        name="1GB Standard Instance",
        ram=nil,
        disk=nil,
        vcpus=nil,
        links=[{"href"=>"https://dfw.servers.api.rackspacecloud.com/v2/772045/flavors/3", "rel"=>"self"}, {"href"=>"https://dfw.servers.api.rackspacecloud.com/772045/flavors/3", "rel"=>"bookmark"}]
      >,
	…


## Get Flavor

To retrieve individual flavor:

	service.flavor.get 2
	
This returns a `Fog::Compute::RackspaceV2::Flavor` instance:

	<Fog::Compute::RackspaceV2::Flavor
    id="2",
    name="512MB Standard Instance",
    ram=512,
    disk=20,
    vcpus=1,
    links=[{"href"=>"https://dfw.servers.api.rackspacecloud.com/v2/772045/flavors/2", "rel"=>"self"}, {"href"=>"https://dfw.servers.api.rackspacecloud.com/772045/flavors/2", "rel"=>"bookmark"}]
    >


## List Servers

To retrieve a list of available  servers:

	service.servers

This returns a collection of `Fog::Compute::RackspaceV2::Servers` models:
	
	<Fog::Compute::RackspaceV2::Servers
    [
      <Fog::Compute::RackspaceV2::Server
        id="6a273531-8ee4-4bef-ad1a-baca963f8bbb",
        name="rax-example",
        created="2013-01-17T22:28:14Z",
        updated="2013-01-17T22:31:19Z",
        host_id="7361c18d94a9933039dae57ae07b0a39fdb39ea3775a25329086531f",
        state="ACTIVE",
        progress=100,
        user_id="296063",
        tenant_id="772045",
        links=[{"href"=>"https://dfw.servers.api.rackspacecloud.com/v2/772045/servers/6a273531-8ee4-4bef-ad1a-baca963f8bbb", "rel"=>"self"}, {"href"=>"https://dfw.servers.api.rackspacecloud.com/772045/servers/6a273531-8ee4-4bef-ad1a-baca963f8bbb", "rel"=>"bookmark"}],
        metadata={},
        personality=nil,
        ipv4_address="198.101.255.186",
        ipv6_address="2001:4800:780e:0510:0fe1:75e8:ff04:c4a0",
        disk_config="AUTO",
        bandwidth=[],
        addresses={"public"=>[{"version"=>4, "addr"=>"198.101.255.186"}, {"version"=>6, "addr"=>"2001:4800:780e:0510:0fe1:75e8:ff04:c4a0"}], "private"=>[{"version"=>4, "addr"=>"10.180.22.165"}]},
        flavor_id="2",
        image_id="33e21646-43ed-407e-9dbf-7c7873fccd9a"
      >,
    …

## Get Server

To return an individual server:

	service.servers.get "6a273531-8ee4-4bef-ad1a-baca963f8bbb"
	
This returns a `Fog::Compute::RackspaceV2::Server` instance:

	<Fog::Compute::RackspaceV2::Servers
    [
      <Fog::Compute::RackspaceV2::Server
        id="6a273531-8ee4-4bef-ad1a-baca963f8bbb",
        name="rax-example",
        created="2013-01-17T22:28:14Z",
        updated="2013-01-17T22:31:19Z",
        host_id="7361c18d94a9933039dae57ae07b0a39fdb39ea3775a25329086531f",
        state="ACTIVE",
        progress=100,
        user_id="296063",
        tenant_id="772045",
        links=[{"href"=>"https://dfw.servers.api.rackspacecloud.com/v2/772045/servers/6a273531-8ee4-4bef-ad1a-baca963f8bbb", "rel"=>"self"}, {"href"=>"https://dfw.servers.api.rackspacecloud.com/772045/servers/6a273531-8ee4-4bef-ad1a-baca963f8bbb", "rel"=>"bookmark"}],
        metadata={},
        personality=nil,
        ipv4_address="198.101.255.186",
        ipv6_address="2001:4800:780e:0510:0fe1:75e8:ff04:c4a0",
        disk_config="AUTO",
        bandwidth=[],
        addresses={"public"=>[{"version"=>4, "addr"=>"198.101.255.186"}, {"version"=>6, "addr"=>"2001:4800:780e:0510:0fe1:75e8:ff04:c4a0"}], "private"=>[{"version"=>4, "addr"=>"10.180.22.165"}]},
        flavor_id="2",
        image_id="33e21646-43ed-407e-9dbf-7c7873fccd9a"
      >,
    ...

## Create Server

If you are interested in creating a server utilizing ssh key authenication, you are recommended to use [bootstrap](#bootstrap) method.

To create a server:

	flavor = service.flavors.first
	image = service.images.first
	server = service.servers.create(:name => 'fog-doc', :flavor_id => flavor.id, :image_id => image.id)

**Note**: The `:name`, `:flavor_id`, and `image_id` attributes are required for server creation.

This will return a `Fog::Compute::RackspaceV2::Server` instance:

	<Fog::Compute::RackspaceV2::Server
    id="8ff308a6-e04a-4602-b991-ed526ab3b6be",
    name="fog-server",
    created=nil,
    updated=nil,
    host_id=nil,
    state=nil,
    progress=nil,
    user_id=nil,
    tenant_id=nil,
    links=[{"href"=>"https://dfw.servers.api.rackspacecloud.com/v2/772045/servers/8ff308a6-e04a-4602-b991-ed526ab3b6be", "rel"=>"self"}, {"href"=>"https://dfw.servers.api.rackspacecloud.com/772045/servers/8ff308a6-e04a-4602-b991-ed526ab3b6be", "rel"=>"bookmark"}],
    metadata=nil,
    personality=nil,
    ipv4_address=nil,
    ipv6_address=nil,
    disk_config="AUTO",
    bandwidth=nil,
    addresses=nil,
    flavor_id=2,
    image_id="3afe97b2-26dc-49c5-a2cc-a2fc8d80c001"
  	>

Notice that your server contains several `nil` attributes. To see the latest status, reload the instance as follows:

	server.reload
	
You can see that the server is currently 17% built:

	Fog::Compute::RackspaceV2::Server
    id="8ff308a6-e04a-4602-b991-ed526ab3b6be",
    name="fog-server",
    created="2013-01-18T16:15:41Z",
    updated="2013-01-18T16:16:14Z",
    host_id="775837108e45aa3f2a58527c9c3b6160838078e83148f07906c933ca",
    state="BUILD",
    progress=17,
    user_id="296063",
    tenant_id="772045",
    links=[{"href"=>"https://dfw.servers.api.rackspacecloud.com/v2/772045/servers/8ff308a6-e04a-4602-b991-ed526ab3b6be", "rel"=>"self"}, {"href"=>"https://dfw.servers.api.rackspacecloud.com/772045/servers/8ff308a6-e04a-4602-b991-ed526ab3b6be", "rel"=>"bookmark"}],
    metadata={},
    personality=nil,
    ipv4_address="",
    ipv6_address="",
    disk_config="AUTO",
    bandwidth=[],
    addresses={"public"=>[{"version"=>4, "addr"=>"198.61.209.78"}, {"version"=>6, "addr"=>"2001:4800:7810:0512:0fe1:75e8:ff04:94e4"}], "private"=>[{"version"=>4, "addr"=>"10.181.13.198"}]},
    flavor_id="2",
    image_id="3afe97b2-26dc-49c5-a2cc-a2fc8d80c001"
  >

You will be unable to perform any actions to this server until it reaches an `ACTIVE` state. Since this is true for most server actions, Fog provides the convenience method `wait_for`.

Fog can wait for the server to become ready as follows:

	server.wait_for { ready? }
	
**Note**: The `Fog::Compute::RackspaceV2::Server` instance returned from the create method contains a `password` attribute. The `password` attribute will NOT be present in subsequent retrievals either through `service.servers` or `server.servers.get my_server_id`.

### Additional Parameters

The `create` method also supports the following key values:

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:disk_config</td>
		<td>The disk configuration value (AUTO or MANUAL). Refer to  Next Gen Server API documentation - <a href="http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_extensions.html#diskconfig_attribute">Disk Configuration Extension</a>.</td>
	</tr>
	<tr>
		<td>:metadata</td>
		<td>Hash containing server metadata.</td>
	</tr>
	<tr>
		<td>:personality</td>
		<td>Array of files to be injected onto the server. Please refer to the Fog <a href="http://rubydoc.info/github/fog/fog/Fog/Compute/RackspaceV2/Server:personality">personality </a> API documentation for further information.</td>
	</tr>
	<tr>
		<td>:config_drive</td>
		<td>Whether a read-only configuration drive is attached. Refer to  Next Gen Server API documentation - <a
href="http://docs.rackspace.com/servers/api/v2/cs-devguide/content/config_drive_ext.html">Config Drive Extension</a>.</td>
	</tr>
        <tr>
                <td>:networks</td>
                <td>Array of uuids corresponding to cloud networks that should be attached to the server, and defaults to two elements (all-zeros for public internet and all-ones for ServiceNet). Please refer to the Rackspace <a href="http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html">Create Server </a> API documentation for further information.</td>
        </tr>
</table>

## Bootstrap

In addition to the `create` method, Fog provides a `bootstrap` method which creates a server and then performs the following actions via ssh:

1. Create `ROOT_USER/.ssh/authorized_keys` file using the ssh key specified in `:public_key_path`.
2. Lock password for root user using `passwd -l root`.
3. Create `ROOT_USER/attributes.json` file with the contents of `server.attributes`.
4. Create `ROOT_USER/metadata.json` file with the contents of `server.metadata`.

**Note**: Unlike the `create` method, `bootstrap` is blocking method call. If non-blocking behavior is desired, developers should use the `:personality` parameter on the `create` method.

The following example demonstrates bootstraping a server:

	service.servers.bootstrap :name => 'bootstrap-server',
	:flavor_id => service.flavors.first.id,
	:image_id => service.images.find {|img| img.name =~ /Ubuntu/}.id,
	:public_key_path => '~/.ssh/fog_rsa.pub',
	:private_key_path => '~/.ssh/fog_rsa'

**Note**: The `:name`, `:flavor_id`, `:image_id`, `:public_key_path`, `:private_key_path` are required for the `bootstrap` method.

The `bootstrap` method uses the same additional parameters as the `create` method. Refer to the [Additional Parameters](#additional-parameters) section for more information.

## SSH

Once a server has been created and set up for ssh key authentication, fog can execute remote commands as follows:

	result = server.ssh ['pwd']
	
This will return the following:

	[#<Fog::SSH::Result:0x1108241d0 @stderr="", @status=0, @stdout="/root\r\n", @command="pwd">]

**Note**: SSH key authentication can be set up using `bootstrap` method or by using the `:personality` attribute on the `:create` method. See [Bootstrap](#bootstrap) or [Create Server](#create-server) for more information.

## Update Server

Next Gen Cloud Servers support updating the following attributes `name`, `access_ipv4_address`, and `access_ipv6_address`.

To update these attributes:

	server.name = "batman"
	server.access_ipv4_address = "10.0.0.1"
	server.access_ipv6_address = "fdbb:1717:4533:7c89:0:0:0:1"
	server.save
	
Additional information about server access addresses can be found [here](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Primary_Addresses-d1e2558.html).
	
**Note**: Updating the server name does not change the host name. Names are not guaranteed to be unique.

## Delete Server

To delete a server:

	server.destroy
	
**Note**: The server is not immediately destroyed, but it does occur shortly there after.

## Metadata

You can access metadata as an attribute on both `Fog::Compute::RackspaceV2::Server` and `Fog::Compute::RackspaceV2::Metadata::Image`. You can specify metadata during creation of a server or an image. Please refer to [Create Server](#create-server) or [Create Image](#create-image) sections for more information.

This example demonstrates how to iterate through a server's metadata:

	server.metadata.each {|metadatum| puts "#{metadatum.key}: #{metadatum.value}" }

You can update and retrieve metadata in a manner similar to a hash:

	server.metadata["os_type"]
	
	server.metadata["installed_ruby"] = "MRI 1.9.3"

Metadata also responds to `save` and `reload` as follows:

	server.metadata.save
	
	server.metadata.reload


## Change Admin Password

To change the administrator password:

	server.change_admin_password "superSecure"

## Reboot

To perform a soft reboot:

	server.reboot
	
To perform a hard reboot:
	
	server.reboot 'HARD'

## Rebuild

Rebuild removes all data on the server and replaces it with the specified image. The id and all IP addresses remain the same.

To rebuild a server:

	image = service.images.first
	server.rebuild image.id
	
Additionally, the `rebuild` method will take a second parameter containing a hash with the following values:

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:name</td>
		<td>Name of Server</td>
	</tr>
	<tr>
		<td>:flavorRef</td>
		<td>Flavor id</td>
	</tr>
	<tr>
		<td>:accessIPv4</td>
		<td>IPv4 access address</td>
	</tr>
	<tr>
		<td>:accessIPv6</td>
		<td>IPv6 access address</td>		
	</tr>
	<tr>
		<td>:metadata</td>
		<td>Hash containing server metadata</td>
	</tr>
	<tr>
		<td>:personality</td>
		<td>File path and contents. Refer to Next Gen Server API documentation - <a href="http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Personality-d1e2543.html">Server Personality</a>. </td>
	</tr>
	<tr>
		<td>:disk_config</td>
		<td>The disk configuration value (AUTO or MANUAL). Refer to  Next Gen Server API documentation - <a href="http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_extensions.html#diskconfig_attribute">Disk Configuration Extension</a>.</td>
	</tr>
</table>

## Resize

Resizing a server allows you to change the resources dedicated to the server.

To resize a server:

	flavor_id = service.flavor[2].id
	server.resize flavor_id  #flavor_id should be your desired flavor

During the resize process the server will have a state of `RESIZE`. Once a server has completed resizing it will be in a `VERIFY_RESIZE` state.

You can use Fog's `wait_for` method to wait for this state as follows:

		server.wait_for { ready?('VERIFY_RESIZE', ['ACTIVE', 'ERROR']) }
	

In this case, `wait_for` is waiting for the server to become `VERIFY_READY` and will raise an exception if we enter an `ACTIVE` or `ERROR` state.

Once a server enters the `VERIFY_RESIZE` we will need to call `confirm_resize` to confirm the server was properly resized or `revert_resize` to rollback to the old size/flavor.

**Note:** A server will automatically confirm resize after 24 hours.

To confirm resize:

	server.confirm_resize
	
To revert to previous size/flavor:

	server.revert_resize
	

## Create Image

To create an image of your server:

	image = server.create_image "back-image-#{server.name}", :metadata => { :environment => 'development' }

You can use the second parameter to specify image metadata. This is an optional parameter.

During the imaging process, the image state will be `SAVING`. The image is ready for use when when state `ACTIVE` is reached. Fog can use `wait_for` to wait for an active state as follows:

	image.wait_for { ready? }

## List Attached Volumes
To list Cloud Block Volumes attached to server:

	server.attachments
	
## Attach Volume
To attach volume using the volume id:

	server.attach_volume "0e7a706c-340d-48b3-802d-192850387f93"
	
If the volume id is unknown you can look it up using the Cloud Block Storage service. Start by creating a `cbs_service` similar to our Compute Service:

	cbs_service = Fog::Rackspace::BlockStorage.new({
  		:rackspace_username  => RACKSPACE_USER_NAME, # Your Rackspace Username
  		:rackspace_api_key   => RACKSPACE_API        # Your Rackspace API key
	})

	volume = cbs_service.volumes.first
	server.attach_volume volume, "/dev/xvdb" # name of device on server is optional
	
The `attach_volume` method accepts a volume id `String` or `Fog::Rackspace::BlockStorage::Volume` instance. This example also demonstrates passing in the optional device name. Valid device names are `/dev/xvd[a-p]`.
	
## Detach Volume
To detach a volume:

	server.attachments.first.detach
		
## Examples

Example code using Next Gen Cloud Servers can be found [here](https://github.com/fog/fog/tree/master/lib/fog/rackspace/examples).

## Additional Resources

* [fog.io](http://fog.io/)
* [Fog rdoc](http://rubydoc.info/gems/fog/)
* [Fog Github repo](https://github.com/fog/fog)
* [Fog Github Issues](https://github.com/fog/fog/issues)
* [Excon Github repo](https://github.com/geemus/excon)
* [Next Gen Cloud Servers API](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_preface.html)

## Support and Feedback

Your feedback is appreciated! If you have specific issues with the **fog** SDK, you should file an [issue via Github](https://github.com/fog/fog/issues).

For general feedback and support requests, please visit: https://developer.rackspace.com/support.

