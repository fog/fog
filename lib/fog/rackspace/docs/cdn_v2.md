#Rackspace CDNV2

This document explains how to get started using CDNV2 with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

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

Next, create a connection to Rackspace's CDNV2 API:

Using a US-based account:

	service = Fog::Rackspace::CDNV2.new({
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

By default `Fog::Rackspace::CDNV2` will authenticate against the US authentication endpoint and connect to the DFW region. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

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

The request abstraction maps directly to the [CDNV2 API](http://docs.rackspace.com/networks/api/v2/cn-devguide/content/ch_overview.html). It provides the most efficient interface to the Rackspace CDNV2

To see a list of requests supported by the service:

	service.requests

This returns:

  	[:create_service, :delete_assets, :delete_service, :get_flavor, :get_home_document, :get_ping, :get_service, :list_flavors, :list_services, :update_service]

#### Example Request

To request a list of services:

	response = service.list_services

This returns in the following `Excon::Response`:

  	#<Excon::Response:0x007ff0ea6b4c88 @data={:body=>{"services"=>[{"name"=>"SomethingDifferent.net", "domains"=>[{"domain"=>"google.com", "protocol"=>"http"}], "origins"=>[{"origin"=>"google.com", "port"=>80, "ssl"=>false, "rules"=>[]}], "restrictions"=>[], "caching"=>[], "status"=>"create_in_progress", "flavor_id"=>"cdn", "errors"=>[]

To view the status of the response:

	response.status

**Note**: Fog is aware of valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response body:

	response.body

This will return:

  	{"services"=>[{"name"=>"SomethingDifferent.net", "domains"=>[{"domain"=>"google.com",...


To learn more about CDNV2 request methods refer to [rdoc](http://www.rubydoc.info/gems/fog/Fog/Rackspace/CDNV2/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

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

## List Services

To retrieve a list of available services:

	service.services

This returns a collection of `Fog::Rackspace::CDNV2::Service` models:

  	<Fog::Rackspace::CDNV2::Services
      [
        <Fog::Rackspace::CDNV2::Service
          id="087ffeb0-462d-4f44-b24a-2914fbfb1d42",
          name="SomethingDifferent.net",
          domains=[{"domain"=>"google.com", "protocol"=>"http"}],
          origins=[{"origin"=>"google.com", "port"=>80, "ssl"=>false, "rules"=>[]}],
          caching=[],
          restrictions=[],
          flavor_id="cdn",
          status="create_in_progress",
          links=[{"href"=>"", "rel"=>"self"}, {"href"=>"...", "rel"=>"flavor"}]
          ...


## Create Service

Create a service:

	  s = service.services.new
	  s.name = "work.com"
	  s.flavor_id = "cdn"
	  s.add_domain "google.com"
	  s.add_origin "google.com"
	  s.save

## Update Service
You may add, remove, or update. -- **DOCS NEEDED** --

	  s = service.services.first
	  s.add_operation({
        op: "add",
        path: "/domains/0",
        value: {
          origin: "cdn.somewhere.org",
          port: 80,
          ssl: false,
          rules: [
            {
              name: "Something",
              request_url: "google.com"
            }
          ]
        }
      })

      s.save

## Get Service

To retrieve individual service:

	  service.services.get "087ffeb0-462d-4f44-b24a-2914fbfb1d42"

This returns an `Fog::Rackspace::CDNV2::Service` instance:

    <Fog::Rackspace::CDNV2::Service
      id="087ffeb0-462d-4f44-b24a-2914fbfb1d42"
      name="work.com",
      domains=[{"domain"=>"google.com", "protocol"=>"http"}],
      origins=[{"origin"=>"google.com", "port"=>80, "ssl"=>false, "rules"=>[]}],
      caching=[],
      restrictions=[],
      flavor_id="cdn",
      status="create_in_progress",
      links=[{"href"=>"", "rel"=>"self"}, {"href"=>"...", "rel"=>"flavor"}]

## Delete Service

To delete a service:

    service.destroy

**Note**: The service is not immediately destroyed, but it does occur shortly there after.

## Delete Service Assets

To delete a service's assets (or any owned asset via url):

    service.destroy_assets(url: "/")

**Note**: The service's asset is not immediately destroyed, but it does occur shortly there after.


## List Flavors

To retrieve a list of available flavors:

	service.flavors

This returns a collection of `Fog::Rackspace::CDNV2::Flavor` models:

	  <Fog::Rackspace::CDNV2::Flavors
	    [
	      <Fog::Rackspace::CDNV2::Flavor
	        id="cdn",
	        providers=[{"provider"=>"akamai", "links"=>[{"href"=>"http://www.akamai.com", "rel"=>"provider_url"}]}],
	        links=[{"href"=>"...", "rel"=>"self"}]
	      >
	    ]
	  >

## Get Flavor

To retrieve individual flavor:

	  service.flavors.get "cdn"

This returns an `Fog::Rackspace::CDNV2::Flavor` instance:

	  <Fog::Rackspace::CDNV2::Flavor
	    id="cdn",
	    providers=[{"provider"=>"akamai", "links"=>[{"href"=>"http://www.akamai.com", "rel"=>"provider_url"}]}],
	    links=[{"href"=>"...", "rel"=>"self"}]
	  >

## Ping

To ping the CDN:

	  service.ping

This returns an boolean based on successful ping.

## Get Home Document

To retrieve the home document:

    service.home_document

This returns a JSON blob that describes the home document.

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
