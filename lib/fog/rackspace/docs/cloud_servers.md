#Next Gen Cloud Servers™ (compute_v2)

This document will explain how to get started using Next Gen Cloud Servers™ with Fog. User should have read to [Getting Started with Rackspace Open Cloud](/getting_started.md).


## Starting irb console
Start by executing the following command:

	irb
	
Once `irb` has launched you will need to require the Fog library. 

If using Ruby 1.8.x execute the following command:

	require 'rubygems'
	require 'fog'

If using Ruby 1.9.x execute the following command:

	require 'fog'
	
## Create Service
Start by creating connection to the Next Gen Cloud Servers™ by creating an instance of `Fog::Compute`:

	service = Fog::Compute.new({
  		:provider            => 'Rackspace',
  		:rackspace_username  => RACKSPACE_USER_NAME,
  		:rackspace_api_key   => RACKSPACE_API,
  		:version => :v2
	})

Values in uppercase should be replaced with the proper Rackspace Open Cloud credentials. To learn more about obtaining Cloud Credentials visit the [Getting Started](/getting_started.md) document. 

By default `Fog::Compute` will connect to the DFW region. In order connect to the ORD region you will need to  

To use the ORD region you will need to add the key `:rackspace_endpoint` with a value of `Fog::Compute::RackspaceV2::ORD_ENDPOINT` to the `Fog::Compute` constructor. To interact with the London Region you will need to add the key `:rackspace_endpoint` with a value of Fog::Compute::RackspaceV2::LON_ENDPOINT as well as specifying the authentication with  `:rackspace_auth_url` https://lon.auth.api.rackspacecloud.com/v1.0

#### Endpoints
By default `Fog::Compute` will authenticate against the US Rackspace Open Cloud and create servers in the DFW region. 

Alernative data centers can be specificed by adding the key `:rackspace_endpoint` into the constructor specifing one of the following values:

<table>
	<tr>
		<th>Value</th>
		<th>Location</th>
	</tr>
	<tr>
		<td>Fog::Compute::RackspaceV2::DFW_ENDPOINT</td>
		<td>Dallas Region</td>
	</tr>
	<tr>
		<td>Fog::Compute::RackspaceV2::ORD_ENDPOINT</td>
		<td>Chicago Region</td>
	</tr>
	<tr>
		<td>Fog::Compute::RackspaceV2::LON_ENDPOINT</td>
		<td>London Region</tr>
</table>

**Please Note:** If you specify the London region you must specify the `:rackspace_auth_url`




