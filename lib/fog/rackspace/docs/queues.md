#Cloud Queues (queues)

This document explains how to get started using queues with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

## Basic Concepts

Cloud Queues is an open source, scalable, and highly available message and notifications service, based on the OpenStack Marconi project. Users of this service can create and manage a producer-consumer or a publisher-subscriber model. Unlimited queues and messages give users the flexibility they need to create powerful web applications in the cloud.

It consists of a few basic components: queues, messages, claims, and statistics. In the producer-consumer model, users create queues in which producers, or servers, can post messages. Workers, or consumers, can then claim those messages and delete them after they complete the actions associated with the messages. A single claim can contain multiple messages, and administrators can query claims for status.

In the publisher-subscriber model, messages are posted to a queue as in the producer-consumer model, but messages are never claimed. Instead, subscribers, or watchers, send GET requests to pull all messages that have been posted since their last request. In this model, a message remains in the queue, unclaimed, until the message's time to live (TTL) has expired.

In both of these models, administrators can get queue statistics that display the most recent and oldest messages, the number of unclaimed messages, and more.

## Starting irb console

Start by executing the following command:

	irb

Once `irb` has launched you need to require the Fog library as follows:

	require 'fog'

## Create Service

Next, create a connection to queue service:

Using a US-based account:

	service = Fog::Rackspace::Queues.new(
		:rackspace_username  => RACKSPACE_USER_NAME,   # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,         # Your Rackspace API key
		:rackspace_region    => :ord,                  # Your desired region
		:rackspace_queues_client_id => CLIENT_ID,      # Your client ID
		:connection_options  => {}                     # Optional connection options
	)

Using a UK-based account:

	service = Fog::Rackspace::Queues.new(
		:rackspace_username  => RACKSPACE_USER_NAME,        # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,              # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
		:rackspace_region    => :lon,                       # Your desired region
		:rackspace_queues_client_id =>  CLIENT_ID',         # Your client ID
		:connection_options  => {}                          # Optional connection options
	)

To learn more about obtaining cloud credentials refer to the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

### Authentication Endpoint

By default `Fog::Rackspace::Queues` will authenticate against the US authentication endpoint. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

### Regions

Alternative regions are specified using the key `:rackspace_region `. A list of regions available for cloud queues can be found by executing the following:

	identity_service = Fog::Identity({
		:provider            => 'Rackspace',                     # Rackspace Fog provider
		:rackspace_username  => RACKSPACE_USER_NAME,             # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,                   # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT # Not specified for US Cloud
	})

	identity_service.service_catalog.display_service_regions :queues

### Private Cloud

Rackspace Private Cloud installations can skip specifying a region and directly specify their custom service endpoints using the key `:rackspace_queues_url`.

**Note**: A`Fog::Rackspace::Queues` instance is needed for the desired region.

### Client ID

The Rackspace Queue service requires that every client define a client id to help identify messages and claims specific to the client. This client id should take the form of a UUID and can be generated using fog as follows:

    Fog::UUID.uuid

If the client id is omitted fog will generate one for you.

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

Fog provides both a **model** and **request** abstraction. The request abstraction provides the most efficient interface and the model abstraction wraps the request abstraction to provide a convenient `ActiveModel`-like interface.

### Request Layer

The request abstraction maps directly to the [Queue API](http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/overview.html). It provides the most efficient interface to the Rackspace Open Cloud.

To see a list of requests supported by the service:

	service.requests

This returns:

	    :list_queues, :get_queue, :create_queue, :delete_queue, :get_queue_stats, :list_messages, :get_message, :create_message, :delete_message, :create_claim, :get_claim, :update_claim, :delete_claim


#### Example Request

To request a list of queues:

	response = service.list_queues

This returns in the following `Excon::Response`:

	#<Excon::Response:0x007feddda06e00 @data={:body=>{"queues"=>[{"href"=>"/v1/queues/demo-queue", "name"=>"demo-queue"}], "links"=>[{"href"=>"/v1/queues?marker=demo-queue", "rel"=>"next"}]}, :headers=>{"Content-Length"=>"119", "Content-Type"=>"application/json; charset=utf-8", "Content-Location"=>"/v1/queues", "X-Project-ID"=>"5551212"}, :status=>200, :remote_ip=>"10.10.0.1"}, @body="{\"queues\": [{\"href\": \"/v1/queues/demo-queue\", \"name\": \"demo-queue\"}], \"links\": [{\"href\": \"/v1/queues?marker=demo-queue\", \"rel\": \"next\"}]}", @headers={"Content-Length"=>"119", "Content-Type"=>"application/json; charset=utf-8", "Content-Location"=>"/v1/queues", "X-Project-ID"=>"5551212"}, @status=200, @remote_ip="10.10.0.1">

To view the status of the response:

	response.status

**Note**: Fog is aware of valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response body:

	response.body

This returns:

	{"queues"=>[{"href"=>"/v1/queues/demo-queue", "name"=>"demo-queue"}], "links"=>[{"href"=>"/v1/queues?marker=demo-queue", "rel"=>"next"}]}


To learn more about queue request methods refer to [rdoc](http://rubydoc.info/gems/fog/Fog/Rackspace/Queues/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

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

## Create Queue

Queues require a unique name. If you try to create a queue with a name that already exists, fog will throw a `Fog::Rackspace::Queues::ServiceError` exception with a 204 status code.

To create a queue named demo-queue

    begin
      queue = service.queues.create :name => 'demo-queue'
    rescue Fog::Rackspace::Queues::ServiceError => e
      if e.status_code == 204
        # duplicate queue exists
      end
    end

## Posting a Message to a Queue

Messages can be any type of data, as long as they do not exceed 256 KB in length. Typical message bodies range from simple values, to a chunk of XML, or a list of JSON values. Fog handles the JSON-encoding required to post the message.

You can post a message a message to your queue as follows:

    queue.messages.create :body => 'The laces were out!', :ttl => 360

You must supply both a body and a value for `ttl`. The value of `ttl` must be between 60 and 1209600 seconds (one minute to 14 days).

## Listing Messages in a Queue

To list messages:

    queue.messages

You can change the behavior by setting the follow attributes on the messages collection:

Parameter | Default | Effect
---- | ---- | ----
**echo** | `true` | When `true`, your own messages are included.
**include_claimed** | `false` | By default, only unclaimed messages are returned. Pass this as `true` to get all messages, claimed or not.
**marker** | `nil` | Used for pagination.
**limit** | `10` | The maximum number of messages to return. Note that you may receive fewer than the specified limit if there aren't that many available messages in the queue.

For example, to include claimed messages:

    queue.messages.include_claimed = true
    queue.messages

## Claiming Messages in a Queue

Claiming messages is how workers processing a queue mark messages as being handled by that worker, avoiding having two workers process the same message.

Messages can be claimed and processed as follows:

    claims = queue.claims.create :ttl => 300, :grace => 100, :limit => 10

The parameters for this call are described in the following table:

Parameter | Default | Notes
---- | ---- | ----
**ttl** |  | The ttl attribute specifies how long the server waits before releasing the claim. The ttl value must be between 60 and 43200 seconds (12 hours).
**grace** |  | The grace attribute specifies the message grace period in seconds. The value of the grace period must be between 60 and 43200 seconds (12 hours). To deal with workers that have stopped responding (for up to 1209600 seconds or 14 days, including claim lifetime), the server extends the lifetime of claimed messages to be at least as long as the lifetime of the claim itself, plus the specified grace period. If a claimed message would normally live longer than the grace period, its expiration is not adjusted.
**limit** | 10 | The number of messages to claim. The maximum number of messages you may claim at once is 20.

If the claim is successful it will return a `Fog::Rackspace::Queues::Claims` object; if there are not any available messages it will return `false`.

To iterate through the claimed messages:

    claim.messages.each do |message|
      # process message here
      message.destroy
    end

**Note:** You will want to call the `destroy` method on the message after processing to insure it is not processed more than once.

## Renewing a Claim

Once a claim has been made, if the TTL and grace period expire, the claim is automatically released and the messages are made available for others to claim. If you have a long-running process and want to ensure that this does not happen in the middle of the process, you should update the claim with one or both of a TTL or grace period. Updating resets the age of the claim, restarting the TTL for the claim. To update a claim, call:

    claim.ttl = 360
    claim.grace = 360
    claim.save

## Refreshing a Claim

If you have a `Fog::Rackspace::Queues::claims` object, keep in mind that it is not a live window into the status of the claim; rather, it is a snapshot of the claim at the time the object was created. To refresh it with the latest information, call its `reload` method. This refreshes all of its attributes with the most current status of the claim.


## Releasing a Claim

If you have a claim on several messages and must abandon processing of those messages for any reason, you should release the claim so that those messages can be processed by other workers as soon as possible, instead of waiting for the claim's TTL to expire. When you release a claim, the claimed messages are immediately made available in the queue for other workers to claim. To release a claim, call:

    claim.destroy
