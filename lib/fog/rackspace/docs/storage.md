#Cloud Files™ (storage)

This document explains how to get started using Cloud Files with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.


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

Next, create a connection to Cloud Files.

Using a US-based account:

	service = Fog::Storage.new({
  		:provider            => 'Rackspace',         # Rackspace Fog provider
  		:rackspace_username  => RACKSPACE_USER_NAME, # Your Rackspace Username
  		:rackspace_api_key   => RACKSPACE_API,       # Your Rackspace API key
		:rackspace_region    => :ord,                # Defaults to :dfw
  		:connection_options  => {}                   # Optional
	})
	
Using a UK-based account:

	service = Fog::Storage.new({
  		:provider            => 'Rackspace',                # Rackspace Fog provider
  		:rackspace_username  => RACKSPACE_USER_NAME,        # Your Rackspace Username
  		:rackspace_api_key   => RACKSPACE_API,              # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
		:rackspace_region    => :lon,
  		:connection_options  => {}                          # Optional
	})

To learn more about obtaining cloud credentials refer to the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

By default `Fog::Storage` will authenticate against the US authentication endpoint and connect to the DFW region. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

Alternative regions are specified using the key `:rackspace_region `. A list of regions available for Cloud Files can be found by executing the following:

	identity_service = Fog::Identity({
		:provider            => 'Rackspace',                     # Rackspace Fog provider
		:rackspace_username  => RACKSPACE_USER_NAME,             # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,                   # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT # Not specified for US Cloud
	})
	
	identity_service.service_catalog.display_service_regions :cloudFiles

Rackspace Private Cloud installations can skip specifying a region and directly specify their custom service endpoints using the keys `:rackspace_storage_url` and `:rackspace_cdn_url`.

**Note**: A`Fog::Storage` instance is needed for the desired region.

### Optional Service Parameters

The Storage service supports the following additional parameters:

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:rackspace_servicenet</td>
		<td>If set to true, the service will access Cloud Files using the internal Rackspace ServiceNet. This option should only be used for internal network connections.</td>
	</tr>
	<tr>
		<td>:rackspace_cdn_ssl</td>
		<td>If set to true, the public_url method will return the SSL based URLs.</td>
	</tr>
	<tr>
		<td>:persistent</td>
		<td>If set to true, the service will use a persistent connection.</td>
	</tr>
	 <tr>
		<td>:rackspace_storage_url</td>
		<td>The endpoint for the Cloud Files service. By default, Fog::Storage will pick the appropriate endpoint for region. This option will typically only be used for Rackspace Private Cloud Access.</td>
	</tr>
	<tr>
		<td>:rackspace_cdn_url</td>
		<td>The endpoint for the CDN service. By default, Fog::Storage pick the appropriate endpoint for region. This option will typically only be used for Rackspace Private Cloud Access.</td>
	</tr>
</table>


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
    <tr>
		<td>:chunk_size</td>
		<td>The chunk size in bytes used for block transfers. By default, Fog uses 1 MB chunks.</td>
	</tr>
</table>


## Fog Abstractions

Fog provides both a **model** and **request** abstraction. The request abstraction provides the most efficient interface and the model abstraction wraps the request abstraction to provide a convenient `ActiveModel` like interface.
	
### Request Layer

The request abstraction maps directly to the [Cloud Files API](http://docs.rackspace.com/files/api/v1/cf-devguide/content/Overview-d1e70.html). It provides the most efficient interface to the Rackspace Open Cloud.

To see a list of requests supported by the storage service:

	service.requests
	
This returns:

	:copy_object, :delete_container, :delete_object, :get_container, :get_containers, :get_object, :get_object_https_url, :head_container, :head_containers, :head_object, :put_container, :put_object, :put_object_manifest, :post_set_meta_temp_url_key
	
To see a list of requests supported by the CDN service:

	service.cdn.requests
	
This returns:

	:get_containers, :head_container, :post_container, :put_container, :delete_object


#### Example Request

To request a view account details:

	response = service.head_containers

This returns in the following `Excon::Response`:

	#<Excon::Response:0x10283fc68 @headers={"X-Account-Bytes-Used"=>"2563554", "Date"=>"Thu, 21 Feb 2013 21:57:02 GMT", "X-Account-Meta-Temp-Url-Key"=>"super_secret_key", "X-Timestamp"=>"1354552916.82056", "Content-Length"=>"0", "Content-Type"=>"application/json; charset=utf-8", "X-Trans-Id"=>"txe934924374a744c8a6c40dd8f29ab94a", "Accept-Ranges"=>"bytes", "X-Account-Container-Count"=>"7", "X-Account-Object-Count"=>"5"}, @status=204, @body="">

To view the status of the response:
	
	response.status
	
**Note**: Fog is aware of the valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response headers:

	response.headers
	
This will return:

	{"X-Account-Bytes-Used"=>"2563554", "Date"=>"Thu, 21 Feb 2013 21:57:02 GMT", "X-Account-Meta-Temp-Url-Key"=>"super_secret_key", "X-Timestamp"=>"1354552916.82056", "Content-Length"=>"0", "Content-Type"=>"application/json; charset=utf-8", "X-Trans-Id"=>"txe934924374a744c8a6c40dd8f29ab94a", "Accept-Ranges"=>"bytes", "X-Account-Container-Count"=>"7", "X-Account-Object-Count"=>"5"}
	
	
To learn more about `Fog::Storage` request methods refer to [rdoc](http://rubydoc.info/gems/fog/Fog/Storage/Rackspace/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

### Model Layer

Fog models behave in a manner similar to `ActiveModel`. Models will generally respond to `create`, `save`,  `destroy`, `reload` and `attributes` methods. Additionally, fog will automatically create attribute accessors.

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
		<td>destroy</td>
		<td>
			Destroys object.<br>
			Note: this is a non-blocking call and object deletion might not be instantaneous.
		</td>
	<tr>
		<td>reload</td>
		<td>Updates object with latest state from service.</td>
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
</table>

The remainder of this document details the model abstraction.

**Note:** Fog refers to Rackspace Cloud containers as directories.

## List Directories

To retrieve a list of directories:

	service.directories
	
This returns a collection of `Fog::Storage::Rackspace::Directory` models:

	<Fog::Storage::Rackspace::Directories
    [
      <Fog::Storage::Rackspace::Directory
        key="blue",
        bytes=434266,
        count=1,
        cdn_cname=nil
      >,
      <Fog::Storage::Rackspace::Directory
        key="brown",
        bytes=761879,
        count=1,
        cdn_cname=nil
      >,
	...

## Get Directory

To retrieve a specific directory:

	service.directories.get "blue"

**Note** As a general rule, only use `get` when you want to iterate over the contents of a `Directory`

This call is similar to...

    service.directories.new :key => "blue"

... except the `get` method makes an HTTP call that returns metadata for up to the first 10,000 files. **This can be slow!**

This returns a `Fog::Storage::Rackspace::Directory` instance:

	<Fog::Storage::Rackspace::Directory
    key="blue",
    bytes=434266,
    count=1,
    cdn_cname=nil
    >

## Create Directory

To create a directory:

	service.directories.create :key => 'backups'
	
To create a directory utilizing CDN:

	service.directories.create :key => 'web-assets', :public => true
	
### Additional Parameters

The `create` method also supports the following key values:

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:metadata</td>
		<td>Hash containing directory metadata.</td>
	</tr>
</table>

	
## Update Directory

Cloud Files supports updating the `public` attribute to enable/disable CDN.

To update this attribute:

	directory.public = false
	directory.save
	
## Delete Directory

To delete a directory:

	directory.destroy
	
**Note**: Directory must be empty before it can be deleted.

## List Files

To list files in a directory:

	directory.files
	
**Note**: File contents is not downloaded until `body` attribute is called.

## Upload Files

To upload a file into a directory:

	file = directory.files.create :key => 'space.jpg', :body => File.open "space.jpg"
	
**Note**: For files larger than 5 GB please refer to the [Upload Large Files](#upload_large_files) section.

If you only need a `Directory` so that you can create a file (as above), you can accomplish this without
an HTTP call as below:

    dir = service.directories.new :key => "blue"
	file = dir.files.new(...)
	file.save

This will **not** retrieve the metadata for files in the `Directory`.

However, if the `Directory` does not already exist in Cloud Files, the `save` call will return with a 404.

In this case, you will need to `save` the `Directory` first...

    dir.save

... before you can...

    file.save

### Additional Parameters

The `create` method also supports the following key values:

<table>
	<tr>
		<th>Key</th>
		<th>Description</th>
	</tr>
	<tr>
		<td>:content_type</td>
		<td>The content type of the object. Cloud Files will attempt to auto detect this value if omitted.</td>
	</tr>
	<tr>
		<td>:access_control_allow_origin</td>
		<td>URLs can make Cross Origin Requests. Format is http://www.example.com. Separate URLs with a space. An asterisk (*) allows all. Please refer to <a href="http://docs.rackspace.com/files/api/v1/cf-devguide/content/CORS_Container_Header-d1e1300.html">CORS Container Headers</a> for more information.</td>
	</tr>
	<tr>
		<td>:origin</td>
		<td>The origin is the URI of the object's host.</td>
	</tr>
	<tr>
		<td>:etag</td>
		<td>The MD5 checksum of your object's data. If specified, Cloud Files will validate the integrity of the uploaded object.</td>
	</tr>
	<tr>
		<td>:metadata</td>
		<td>Hash containing file metadata.</td>
	</tr>
</table>

## Upload Large Files

Cloud Files requires files larger than 5 GB to be uploaded into segments along with an accompanying manifest file. All of the segments must be uploaded to the same container.

	SEGMENT_LIMIT = 5368709119.0  # 5GB -1
	BUFFER_SIZE = 1024 * 1024 # 1MB

	File.open(file_name) do |f|
	  segment = 0
	  until file.eof?
	    segment += 1
	    offset = 0

	    # upload segment to cloud files
	    segment_suffix = segment.to_s.rjust(10, '0')
	    service.put_object("my_container", "large_file/#{segment_suffix}", nil) do
	      if offset <= SEGMENT_LIMIT - BUFFER_SIZE
	        buf = file.read(BUFFER_SIZE).to_s
	        offset += buf.size
	        buf
	      else
	        ''
	      end
	    end
	  end
	end

	# write manifest file
	service.put_object_manifest("my_container", "large_file", 'X-Object-Manifest' => "my_container/large_file/")

Segmented files are downloaded like ordinary files. See [Download Files](#download-files) section for more information.

## Download Files

The most efficient way to download files from a private or public directory is as follows:

	File.open('downloaded-file.jpg', 'w') do | f |
	  directory.files.get("my_big_file.jpg") do | data, remaining, content_length |
	    f.syswrite data
	  end
	end

This will download and save the file in 1 MB chunks. The chunk size can be changed by passing the parameter `:chunk_size` into the `:connection_options` hash in the service constructor.

**Note**: The `body` attribute of file will be empty if a file has been downloaded using this method.

If a file object has already been loaded into memory, you can save it as follows:

	File.open('germany.jpg', 'w') {|f| f.write(file_object.body) }

**Note**: This method is more memory intensive as the entire object is loaded into memory before saving the file as in the example above.


## Accessing Files Through CDN

The CDN service offers several different URLs to access your files.

The simplest is with the default container URL. This can be accessed as follows:

	file.public_url

For a more user-friendly URL, you can create a CNAME DNS record pointing to the URL generated by the `public_url` method. Then set the CNAME on the `Directory` object using the attribute `cdn_cname`. Note, that the `cdn_cname` attribute does not persist and will need to be specified every time a directory object is retrieved.

To access the file using SSL, you need to specify the option `:rackspace_cdn_ssl => true` when creating `Fog::Storage` service. This will cause the `public_url` method to return the SSL-secured URL.
	
To stream content use the following:

	file.streaming_url

To stream video for iOS devices without needing to convert your video use the following:

	file.ios_url
	
	
## Metadata

You can access metadata as an attribute on both `Fog::Storage::Rackspace::Directory` and `Fog::Storage::Rackspace::File`.

This example demonstrates how to iterate through a directory's metadata:

	directory.metadata.each_pair {|metadatum| puts "#{metadatum.key}: #{metadatum.value}" }

You can update and retrieve metadata in a manner similar to a hash:

	directory.metadata[:thumbnails]
	
	file.metadata[:environment] = "development"

Directory metadata is saved when the directory is saved and file metadata is set when the file is saved:
	
	directory.save
	
	file.save
	
Metadata is reloaded when directory or file is reloaded:

	directory.reload
	
	file.reload

## Copy File

Cloud Files supports copying files. To copy files into a container named "trip" with a name of "europe.jpg" do the following:

	file.copy("trip", "europe.jpg")
	
To move or rename a file, perform a copy operation and then delete the old file:

	file.copy("trip", "germany.jpg")
	file.destroy

## Delete File

To delete a file:

	file.destroy
	
## CDN Purge

To immediately remove a file from the CDN network use the following:

	file.purge_from_cdn
	
You may only purge up to 25 objects per day and thus this should only be used in situations where there could be serious personal, business, or security consequences if the object remained in the CDN. To purge a directory, please contact Rackspace support.
	
**Note**: You may only **PURGE** up to 25 objects per day. Any attempt to purge more than this will result in a 498 status code error (Rate Limited).

## Account Information

To view Cloud Files usage execute the following:

	service.account
	
This returns a `Fog::Storage::Rackspace::Account` instance:

	<Fog::Storage::Rackspace::Account
    meta_temp_url_key="lkkl23jl2j3",
    container_count=13,
    bytes_used=2563554,
    object_count=5
  	>

## Examples

Example code using Cloud Files can be found [here](https://github.com/fog/fog/tree/master/lib/fog/rackspace/examples).

## Additional Resources

* [fog.io](http://fog.io/)
* [Fog rdoc](http://rubydoc.info/gems/fog/)
* [Fog Github repo](https://github.com/fog/fog)
* [Fog Github Issues](https://github.com/fog/fog/issues)
* [Excon Github repo](https://github.com/geemus/excon)
* [Cloud Files API](http://docs.rackspace.com/files/api/v1/cf-devguide/content/Overview-d1e70.html)

## Support and Feedback

Your feedback is appreciated! If you have specific issues with the **fog** SDK, you should file an [issue via Github](https://github.com/fog/fog/issues).

For general feedback and support requests, please visit: https://developer.rackspace.com/support.
