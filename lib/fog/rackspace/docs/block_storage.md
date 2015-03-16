#Cloud Block Storage (BlockStorage)

This document explains how to get started using Cloud Block Storage with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

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

Next, create a connection to Cloud Block Storage:

Using a US-based account:

	service = Fog::Rackspace::BlockStorage.new({
		:rackspace_username  => RACKSPACE_USER_NAME, # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,       # Your Rackspace API key
		:rackspace_region    => :ord,                # Defaults to :dfw
		:connection_options  => {}                   # Optional
	})

Using a UK-based account:

	service = Fog::Rackspace::BlockStorage.new({
		:rackspace_username  => RACKSPACE_USER_NAME,        # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,              # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
		:rackspace_region    => :lon,
		:connection_options  => {}                          # Optional
	})

To learn more about obtaining cloud credentials refer to the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

By default `Fog::Rackspace::BlockStorage` will authenticate against the US authentication endpoint and connect to the DFW region. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

Alternative regions are specified using the key `:rackspace_region `. A list of regions available for Cloud Block Storage can be found by executing the following:

	identity_service = Fog::Identity({
		:provider            => 'Rackspace',                     # Rackspace Fog provider
		:rackspace_username  => RACKSPACE_USER_NAME,             # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,                   # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT # Not specified for US Cloud
	})

	identity_service.service_catalog.display_service_regions :cloudBlockStorage

Rackspace Private Cloud installations can skip specifying a region and directly specify their custom service endpoints using the key `:rackspace_block_storage_url`.

**Note**: A`Fog::Rackspace::BlockStorage` instance is needed for the desired region.

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

The request abstraction maps directly to the [Cloud Block Storage API](http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/overview.html). It provides the most efficient interface to the Rackspace Open Cloud.

To see a list of requests supported by the service:

	service.requests

This returns:

	:create_volume, :delete_volume, :get_volume, :list_volumes, :get_volume_type, :list_volume_types, :create_snapshot, :delete_snapshot, :get_snapshot, :list_snapshots


#### Example Request

To request a list of volume types:

	response = service.list_volume_types

This returns in the following `Excon::Response`:

	<Excon::Response:0x10a708fb8 @remote_ip="72.32.164.210", @body="{\"volume_types\": [{\"extra_specs\": {}, \"name\": \"SATA\", \"id\": 1}, {\"extra_specs\": {}, \"name\": \"SSD\", \"id\": 2}]}", @status=200, @headers={"Date"=>"Mon, 18 Mar 2013 20:26:03 GMT", "Content-Length"=>"109", "Content-Type"=>"application/json", "X-Compute-Request-Id"=>"req-9c2093d4-8a41-4d8b-a069-114470d1a0dd"}, @data={:status=>200, :headers=>{"Date"=>"Mon, 18 Mar 2013 20:26:03 GMT", "Content-Length"=>"109", "Content-Type"=>"application/json", "X-Compute-Request-Id"=>"req-9c2093d4-8a41-4d8b-a069-114470d1a0dd"}, :remote_ip=>"72.32.164.210", :body=>{"volume_types"=>[{"name"=>"SATA", "id"=>1, "extra_specs"=>{}}, {"name"=>"SSD", "id"=>2, "extra_specs"=>{}}]}}>

To view the status of the response:

	response.status

**Note**: Fog is aware of valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response body:

	response.body

This will return:

	{"volume_types"=>[{"name"=>"SATA", "id"=>1, "extra_specs"=>{}}, {"name"=>"SSD", "id"=>2, "extra_specs"=>{}}]}


To learn more about Cloud Block Storage request methods refer to [rdoc](http://rubydoc.info/gems/fog/Fog/Rackspace/BlockStorage/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

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


## List Volume Types

To retrieve a list of volume types:

	service.volume_types

This returns a collection of `Fog::Rackspace::BlockStorage::VolumeType` models:

	 <Fog::Rackspace::BlockStorage::VolumeTypes
    [
      <Fog::Rackspace::BlockStorage::VolumeType
        id=1,
        name="SATA",
        extra_specs={}
      >,
      <Fog::Rackspace::BlockStorage::VolumeType
        id=2,
        name="SSD",
        extra_specs={}
      >
    ]
  >

## List Volumes

To retrieve a list of volumes:

	service.volumes

This returns a collection of `Fog::Rackspace::BlockStorage::Volume` models:

	 <Fog::Rackspace::BlockStorage::Volumes
    [
      <Fog::Rackspace::BlockStorage::Volume
        id="a53a532f-546c-4da3-8c2d-b26be1046630",
        created_at="2013-03-19T14:19:16.000000",
        state="available",
        display_name="fog-ssd",
        display_description=nil,
        size=100,
        attachments=[],
        volume_type="SSD",
        availability_zone="nova"
      >,
      <Fog::Rackspace::BlockStorage::Volume
        id="e2359473-9933-483f-90df-deb4a9fb25ae",
        created_at="2013-03-19T14:16:45.000000",
        state="available",
        display_name="fog-example",
        display_description=nil,
        size=100,
        attachments=[],
        volume_type="SATA",
        availability_zone="nova"
      >
    ]
  >

## Get Volume

To retrieve an individual volume:

	service.volume.get "fog-example"

This returns a `Fog::Rackspace::BlockStorage::Volume`:

	<Fog::Rackspace::BlockStorage::Volume
        id="e2359473-9933-483f-90df-deb4a9fb25ae",
        created_at="2013-03-19T14:16:45.000000",
        state="available",
        display_name="fog-example",
        display_description=nil,
        size=100,
        attachments=[],
        volume_type="SATA",
        availability_zone="nova"
      >

## Create Volume

To create a volume:

	volume = service.volumes.create(:size => 100, :display_name => 'fog-ssd', :volume_type => 'SSD')

This will return a `Fog::Rackspace::BlockStorage::Volume`:

	<Fog::Rackspace::BlockStorage::Volume
    id="a53a532f-546c-4da3-8c2d-b26be1046630",
    created_at="2013-03-19T14:19:16.000000",
    state="available",
    display_name="fog-ssd",
    display_description=nil,
    size=100,
    attachments=[],
    volume_type="SSD",
    availability_zone="nova"
  >

**Note**: The `:size` parameter is the only required parameter and is in gigabytes. Volumes must be a minimum of 100 GB.

### Additional Parameters

The `create` method also supports the following key values:

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:display_name</td>
		<td>The name of the volume.</td>
	</tr>
	<tr>
		<td>:display_description</td>
		<td>A description of the volume.</td>
	</tr>
	<tr>
		<td>:snapshot_id</td>
		<td>The optional snapshot from which to create a volume.</td>
	</tr>
	<tr>
		<td>:volume_type</td>
		<td>The type of volume to create. Refer to <a href="#list-volume-types">List Volume Types</a> section for valid types. SATA is the default volume type.</td>
	</tr>
</table>

## Attach Volume

Please refer to the [Attach Volume](compute_v2.md#attach-volume) section in the [Next Generation Cloud Servers™ (compute_v2)](compute_v2.md) documentation.

## Detach Volume

Please refer to the [Detach Volume](compute_v2.md#detach-volume) section in the [Next Generation Cloud Servers™ (compute_v2)](compute_v2.md) documentation.


## Delete Volume

To delete a volume:

	volume.destroy

**Note**: You cannot delete a volume until all of its dependent snapshots have been deleted.

## List Snapshots

To retrieve a list of snapshots:

	service.snapshots

To retrieve a list of snapshots for a given volume:

	volume.snapshots

## Create Snapshot

A snapshot is a point-in-time copy of a volume. Each subsequent snapshot will be the difference between the previous snapshot and the current volume.

To create a snapshot of a given volume:

	volume.create_snapshot :display_name => 'initial-snapshot'

**Note**: All writes to the volume should be flushed before creating the snapshot, either by unmounting any file systems on the volume or by detaching the volume.

### Additional Parameters

The `create_snapshot` method also supports the following key values:

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:display_name</td>
		<td>The name of the snapshot.</td>
	</tr>
	<tr>
		<td>:display_description</td>
		<td>A description of the snapshot.</td>
	</tr>
	<tr>
		<td>:force</td>
		<td>If set to true, snapshot will be taken even if volume is still mounted.</td>
	</tr>
</table>



## Delete Snapshot

To delete a snapshot:

	snapshot.destroy

## Examples

Example code using Cloud Block Storage can be found [here](https://github.com/fog/fog/tree/master/lib/fog/rackspace/examples).

## Additional Resources

* [fog.io](http://fog.io/)
* [Fog rdoc](http://rubydoc.info/gems/fog/)
* [Fog Github repo](https://github.com/fog/fog)
* [Fog Github Issues](https://github.com/fog/fog/issues)
* [Excon Github repo](https://github.com/geemus/excon)
* [Cloud Block Storage API](http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/index.html)

## Support and Feedback

Your feedback is appreciated! If you have specific issues with the **fog** SDK, you should file an [issue via Github](https://github.com/fog/fog/issues).

For general feedback and support requests, please visit: https://developer.rackspace.com/support.
