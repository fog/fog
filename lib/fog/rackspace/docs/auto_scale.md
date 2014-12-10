#Auto Scale (AutoScale)

This document explains how to get started using Auto Scale with Fog. It assumes you have read the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

## Basic Concepts

Auto Scale is a service that enables you to scale your application by adding or removing servers based on monitoring events, a schedule, or arbitrary webhooks.

Auto Scale functions by linking three services:

* Monitoring (such as Monitoring as a Service)
* Auto Scale
* Servers and Load Balancers


## Workflow

A scaling group is monitored by Rackspace Cloud Monitoring. When Monitoring triggers an alarm for high utilization within the Autoscaling group, a webhook is triggered. The webhook calls the Auto Scale service, which consults a policy in accordance with the webhook. The policy determines how many additional Cloud Servers should be added or removed in accordance with the alarm.

Alarms may trigger scaling up or scaling down. Scale-down events always remove the oldest server in the group.

Cooldowns allow you to ensure that you don't scale up or down too fast. When a scaling policy runs, both the scaling policy cooldown and the group cooldown start. Any additional requests to the group are discarded while the group cooldown is active. Any additional requests to the specific policy are discarded when the policy cooldown is active.

It is important to remember that Auto Scale does not configure anything within a server. This means that all images should be self-provisioning. It is up to you to make sure that your services are configured to function properly when the server is started. We recommend using something like Chef, Salt, or Puppet.


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

Next, create a connection to Auto Scale:

Using a US-based account:

	service = Fog::Rackspace::AutoScale.new (
		:rackspace_username  => RACKSPACE_USER_NAME, # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,       # Your Rackspace API key
		:rackspace_region    => :ord,
		:connection_options  => {}                   # Optional
	)

Using a UK-based account:

	service = Fog::Rackspace::AutoScale.new (
		:rackspace_username  => RACKSPACE_USER_NAME,        # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,              # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT,
		:rackspace_region    => :lon,
		:connection_options  => {}                          # Optional
	)

To learn more about obtaining cloud credentials refer to the [Getting Started with Fog and the Rackspace Open Cloud](getting_started.md) document.

By default `Fog::Rackspace::AutoScale` will authenticate against the US authentication endpoint. You can specify alternative authentication endpoints using the key `:rackspace_auth_url`. Please refer to [Alternate Authentication Endpoints](http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html) for a list of alternative Rackspace authentication endpoints.

Alternative regions are specified using the key `:rackspace_region `. A list of regions available for Auto Scale can be found by executing the following:

	identity_service = Fog::Identity.new({
		:provider            => 'Rackspace',                     # Rackspace Fog provider
		:rackspace_username  => RACKSPACE_USER_NAME,             # Your Rackspace Username
		:rackspace_api_key   => RACKSPACE_API,                   # Your Rackspace API key
		:rackspace_auth_url  => Fog::Rackspace::UK_AUTH_ENDPOINT # Not specified for US Cloud
	})

	identity_service.service_catalog.display_service_regions :autoscale

Rackspace Private Cloud installations can skip specifying a region and directly specify their custom service endpoints using the key `:rackspace_auto_scale_url`.


**Note**: A`Fog::Rackspace::AutoScale` instance is needed for the desired region.

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

The request abstraction maps directly to the [Auto Scale API](http://docs.rackspace.com//cas/api/v1.0/autoscale-devguide/content/API_Operations.html). It provides the most efficient interface to the Rackspace Open Cloud.

To see a list of requests supported by the service:

	service.requests

This returns:

	:list_groups, :create_group, :get_group, :delete_group, :get_group_state, :pause_group_state, :resume_group_state, :get_group_config, :update_group_config, :get_launch_config, :update_launch_config, :list_policies, :create_policy, :get_policy, :update_policy, :delete_policy, :execute_policy, :execute_anonymous_webhook, :get_webhook, :list_webhooks, :create_webhook, :update_webhook, :delete_webhook


#### Example Request

To request a list of Auto Scale groups:

	response = service.list_groups

This returns in the following `Excon::Response`:

	#<Excon::Response:0x007fd3ea78af08 @data={:body=>{"groups_links"=>[], "groups"=>[{"paused"=>false, "desiredCapacity"=>0, "links"=>[{"href"=>"https://ord.autoscale.api.rackspacecloud.com/v1.0/555/groups/b45e6107-26ca-4a93-869d-46bf20005df3/", "rel"=>"self"}], "active"=>[], "pendingCapacity"=>0, "activeCapacity"=>0, "id"=>"b45e6107-26ca-4a93-869d-46bf20005df3", "name"=>"fog-scailing-group"}]}, :headers=>{"Content-Type"=>"application/json", "Via"=>"1.1 Repose (Repose/2.8.2)", "x-response-id"=>"4c2a8f70-a7da-479a-bf69-6882b5b6346e", "Date"=>"Fri, 27 Sep 2013 15:38:10 GMT", "Transfer-Encoding"=>"chunked", "Server"=>"Jetty(8.0.y.z-SNAPSHOT)"}, :status=>200, :remote_ip=>"162.209.41.103"}, @body="{\"groups_links\": [], \"groups\": [{\"paused\": false, \"desiredCapacity\": 0, \"links\": [{\"href\": \"https://ord.autoscale.api.rackspacecloud.com/v1.0/555/groups/b45e6107-26ca-4a93-869d-46bf20005df3/\", \"rel\": \"self\"}], \"active\": [], \"pendingCapacity\": 0, \"activeCapacity\": 0, \"id\": \"b45e6107-26ca-4a93-869d-46bf20005df3\", \"name\": \"fog-scailing-group\"}]}", @headers={"Content-Type"=>"application/json", "Via"=>"1.1 Repose (Repose/2.8.2)", "x-response-id"=>"4c2a8f70-a7da-479a-bf69-6882b5b6346e", "Date"=>"Fri, 27 Sep 2013 15:38:10 GMT", "Transfer-Encoding"=>"chunked", "Server"=>"Jetty(8.0.y.z-SNAPSHOT)"}, @status=200, @remote_ip="162.209.41.103">

To view the status of the response:

	response.status

**Note**: Fog is aware of valid HTTP response statuses for each request type. If an unexpected HTTP response status occurs, Fog will raise an exception.

To view response body:

	response.body

returns:

	{"groups_links"=>[], "groups"=>[{"paused"=>false, "desiredCapacity"=>0, "links"=>[{"href"=>"https://ord.autoscale.api.rackspacecloud.com/v1.0/555/groups/b45e6107-26ca-4a93-869d-46bf20005df3/", "rel"=>"self"}], "active"=>[], "pendingCapacity"=>0, "activeCapacity"=>0, "id"=>"b45e6107-26ca-4a93-869d-46bf20005df3", "name"=>"fog-scailing-group"}]}


To learn more about Auto Scale request methods refer to [rdoc](http://rubydoc.info/gems/fog/Fog/Rackspace/AutoScale/Real). To learn more about Excon refer to [Excon GitHub repo](https://github.com/geemus/excon).

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

## The Scaling Group

* The **Scaling Group** is the basic unit of automatic scaling. It determines the minimum and maximum number of servers that exist at any time for the group, the cooldown period between scaling events, the configuration for each new server, the load balancer to add these servers to (optional), and any policies that are used for this group.

### List Scaling Groups

To retrieve the list of your scaling groups:

    service.groups

This returns a collection of `Fog::Rackspace::AutoScale::Group` objects:

    <Fog::Rackspace::AutoScale::Groups
    [
      <Fog::Rackspace::AutoScale::Group
        id="b45e6107-26ca-4a93-869d-46bf20005df3",
        links=[{"href"=>"https://ord.autoscale.api.rackspacecloud.com/v1.0/555/groups/b45e6107-26ca-4a93-869d-46bf20005df3/", "rel"=>"self"}]
      >
    ]
  >

To view the [launch configuration](#launch-configurations) for a group execute the following:

    groups = service.groups
    group = group.first
    group.launch_config

This returns a `Fog::Rackspace::AutoScale::LaunchConfig`:

    <Fog::Rackspace::AutoScale::LaunchConfig
    group=    <Fog::Rackspace::AutoScale::Group
      id="b45e6107-26ca-4a93-869d-46bf20005df3",
      links=[{"href"=>"https://ord.autoscale.api.rackspacecloud.com/v1.0/5555/groups/b45e6107-26ca-4a93-869d-46bf20005df3/", "rel"=>"self"}]
    >,
    type="launch_server",
    args={"loadBalancers"=>[{"port"=>8080, "loadBalancerId"=>9099}], "server"=>{"name"=>"autoscale_server", "imageRef"=>"0d589460-f177-4b0f-81c1-8ab8903ac7d8", "flavorRef"=>"2", "OS-DCF =>diskConfig"=>"AUTO", "metadata"=>{"build_config"=>"core", "meta_key_1"=>"meta_value_1", "meta_key_2"=>"meta_value_2"}, "networks"=>[{"uuid"=>"11111111-1111-1111-1111-111111111111"}, {"uuid"=>"00000000-0000-0000-0000-000000000000"}], "personality"=>[{"path"=>"/root/.csivh", "contents"=>"VGhpcyBpcyBhIHRlc3QgZmlsZS4="}]}}
  >

### Getting the Current State of a Scaling Group

It is sometimes helpful to determine what the current state of a scaling group is in terms of whether it is scaling up, scaling down, or stable.

To see your group's current state execute the following:

    group.state

This returns the following:

    {"paused"=>false, "desiredCapacity"=>0, "links"=>[{"href"=>"https://ord.autoscale.api.rackspacecloud.com/v1.0/555/groups/b45e6107-26ca-4a93-869d-46bf20005df3/", "rel"=>"self"}], "active"=>[], "pendingCapacity"=>0, "activeCapacity"=>0, "id"=>"b45e6107-26ca-4a93-869d-46bf20005df3", "name"=>"fog-scailing-group"}

The `active` key holds a list of the IDs of the servers created as part of this scaling group. The `paused` key shows whether or not the scaling group's response to alarms is active or not. There are 3 'capacity'-related keys: `activeCapacity`, `desiredCapacity`, and `pendingCapacity`:

Key | Represents
---- | ----
**activeCapacity** | The number of active servers that are part of this scaling group
**desiredCapacity** | The target number of servers for this scaling group, based on the combination of configuration settings and monitoring alarm responses
**pendingCapacity** | The number of servers which are in the process of being created (when positive) or destroyed (when negative).

### Pausing a Scaling Group's Policies

To pause a scaling group's execution:

    group.pause

There is a corresponding `resume` method to resume execution:

    group.resume

### Creating a Scaling Group

There are many options available to you when creating a scaling group. In order to ease the burden, a builder is provided.

To create a scaling group with the builder you first include the builder in your script:

    require 'fog/rackspace/models/auto_scale/group_builder'

And then use the builder as follows:

    INTERNET = '00000000-0000-0000-0000-000000000000'
    SERVICE_NET = '11111111-1111-1111-1111-111111111111'

    attributes = {
      :server_name => "testgroup",
      :image => my_image,
      :flavor => 3,
      :networks => [INTERNET, SERVICE_NET],
      :personality => [
        {
          "path" => "/root/.csivh",
          "contents" => "VGhpcyBpcyBhIHRlc3QgZmlsZS4="
        }
      ],
      :max_entities => 3,
      :min_entities => 2,
      :cooldown => 600,
      :name => "MyScalingGroup",
      :metadata => { "created_by" => "autoscale sample script" },
      :load_balancers => {
         :port =>  80,
         :loadBalancerId => 1234
       }
      :launch_config_type => :launch_server
    }

    group = Fog::Rackspace::AutoScale::GroupBuilder.build(service, attributes)
    group.save

This creates the scaling group with the name `MyScalingGroup`, and returns a `Fog::Rackspace::AutoScale::Group` object representing the new group. Since the `:min_entities` is 2, it immediately creates 2 servers for the group, based on the image whose ID is in the variable `my_image`. When they are created, they are then added to the load balancer whose ID is `1234`, and receive requests on port 80.

Note that the `:server_name` parameter represents a base string to which Autoscale prepends a 10-character prefix to create a unique name for each server. The prefix always begins with 'as' and is followed by 8 random hex digits and a dash (-). For example, if you set the server_name to 'testgroup', and the scaling group creates 3 servers, their names would look like these:

    as5defddd4-testgroup
    as92e512fe-testgroup
    asedcf7587-testgroup

**Note**: You will see need to add policies to trigger auto scaling operations. See [Policies Section](#policies) for more information.

#### Parameters
Parameter | Required | Default | Notes
---- | ---- | ---- | ----
**:name** | yes |  |
**:cooldown** | yes |  | Period in seconds after a scaling event in which further events are ignored
**:min_entities** | yes |  |
**:max_entities** | yes |  |
**:launch_config_type** | yes |  | Only option currently is`:launch_server`
**:flavor** | yes |  | Flavor to use for each server that is launched. This can be a `Fog::Compute::RackspaceV2::Flavor` or an ID.
**:server_name** | yes |  | The base name for servers created by Autoscale.
**:image** | yes |  | This can be a `Fog::Compute::RackspaceV2::Image` or an id. This is the image that all new servers are created from.
**:disk_config** | no | MANUAL | Determines if the server's disk is partitioned to the full size of the flavor ('AUTO') or just to the size of the image ('MANUAL').
**:server_metadata** | no |  | Arbitrary key-value pairs you want to associate with your servers.
**:personality** | no |  | Small text files that are created on the new servers. _Personality_ is discussed in the [Rackspace Cloud Servers documentation](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Personality-d1e2543.html)
**:networks** | no |  | Any array of networks to which you want to attach new servers. See the [Create Servers documentation](http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html) for standard network IDs.
**:load_balancers** | no |  | Either a  hash of {:port, :loadBalancerId} or a `Fog::Rackspace::LoadBalancers::LoadBalancer` object.

### Updating a Scaling Configuration Group

A group's scaling configuration can be updated via the `Fog::Rackspace::AutoScale::GroupConfig` object. You can retrieve this object by executing the following:

    group_config = group.group_config

Available options on `group_config` include  `:max_entities`, `:name`, `:cooldown`, `:min_entities`, `:metadata`. To update a scaling group, pass one or more of these as keyword arguments. For example, to change the cooldown period to 2 minutes and increase the maximum entities to 16, you call:

    group_config.cooldown = 120
    group_config.max_entities = 16
    group_config.save

**Note**: If you pass any metadata values in this call, it must be the full set of metadata for the scaling group, since the underlying API call **overwrites** any existing metadata.

### Deleting a Scaling Group

To remove a scaling group, call its `destroy` method:

    group.destroy

Note: you cannot delete a scaling group that has active servers in it. You must first delete the servers by setting the `min_entities` and `max_entities` to zero:

    group_config = group.group_config
    group_config.min_entities = 0
    group_config.max_entities = 0
    group_config.save

Once the servers are deleted you can then delete the scaling group.

## Launch Configurations

Each scaling group has an associated **launch configuration**. This determines the properties of servers that are created in response to a scaling event.

The `:server_name` represents a base string to which Autoscale prepends a 10-character prefix. The prefix always begins with 'as' and is followed by 8 random hex digits and a dash (-). For example, if you set the `server_name` to 'testgroup', and the scaling group creates 3 servers, their names would look like these:

    as5defddd4-testgroup
    as92e512fe-testgroup
    asedcf7587-testgroup

To retrieve the launch config:

    launch_config = group.launch_config

The launch configuration contains two attributes `:type` and `:args`. The only launch type currently available for Auto Scale is `:launch_server`. The `args` attribute contains a hash with the launch server configuration options as follows:

    {"server"=>{
        "name"=>"autoscale_server",
        "imageRef"=>"66448837-1a58-4bd2-a647-9f3272f36263",
        "flavorRef"=>"2",
        "networks"=>[{"uuid"=>"00000000-0000-0000-0000-000000000000"}, {"uuid"=>"11111111-1111-1111-1111-111111111111"}],
        "personality"=>[{"path"=>"/root/.csivh", "contents"=>"VGhpcyBpcyBhIHRlc3QgZmlsZS4="}],
        "OS-DCF =>diskConfig"=>"MANUAL",
        "metadata"=>{}}}

Changes to the args attribute can be saved by executing the `save` method on the `launch_config`. For example if you wanted to change the disk configuration to `AUTO`, you would do the following:

    launch_config.args["server"]["OS-DCF =>diskConfig"] = "AUTO"
    launch_config.save

**Note**: If you pass any metadata values in this call, it must be the full set of metadata for the launch configuration, since the underlying API call **overwrites** any existing metadata.

## Policies

When an alarm is triggered in Cloud Monitoring, it calls the webhook associated with a particular policy. The policy is designed to update the scaling group to increase or decrease the number of servers in response to the particular alarm.

To list the policies for a given scaling group use the following:

    policies = group.policies

### Creating a Policy

To add a policy to a scaling group use the following:

    group.policies.create :name => 'Scale by one server', :cooldown => 360, :type => 'webhook', :change => 1

#### Parameters
Parameter | Required | Default | Notes
---- | ---- | ---- | ----
**:name** | yes |  |
**:type** | yes | | This can be "webhook", "schedule" or "cloud monitoring"
**:cooldown** | yes |  | Period in seconds after a policy execution in which further events are ignored. This is separate from the overall cooldown for the scaling group.
**:change** | no | | Can be positive or negative, which makes this a scale-up or scale-down policy, respectively. If this value is specified you can not specify `:change_percent`.
**:change_percent** | no | | The percentage change to the autoscale group's number of units. If this value is specified you can not specify `:change`.
**:args** | no | | This is used to specify schedule parameters. Please refer to [Policy documentation](http://docs-internal-staging.rackspace.com/cas/api/v1.0/autoscale-devguide/content/POST_createPolicies_v1.0__tenantId__groups__groupId__policies_Policies.html) for more information.

### Updating a Policy

You may update a policy at any time, passing in any or all of the above parameters to change that value. For example, to change the cooldown to 60 seconds, and the number of servers to remove to 3, call:

    policy.cooldown = 60
    policy.change = 3
    policy.save

### Executing a Policy

You don't need to wait for an alarm to be triggered in Cloud Monitoring in order to execute a particular policy. If desired, you may do so manually by calling the policy's `execute` method:

    policy.execute

### Deleting a Policy

To remove a policy, call its `destroy` method:

    policy.destroy

## Webhooks

When an alarm is triggered in Cloud Monitoring, it calls the associated webhook, which in turn causes the policy for that webhook to be executed.

To list the webhooks for a given policy:

    webhooks = policy.webhooks


### Creating a Webhook

To add a webhook to a policy:

    webhook = policy.webhooks.create :name => 'my-webhook'


The `:name` parameter is required; the `:metadata` parameter is optional. You can retrieve the webhook by executing:

    webhook.execution_url

### Updating a Webhook

You may update a webhook at any time to change either its name or its metadata:

    webhook.name = 'webhook1'
    webhook.metadata = {
        :owner => 'webteam'
    }
    webhook.save

**Note**: If you pass any metadata values in this call, it must be the full set of metadata for the Webhook, since the underlying API call **overwrites** any existing metadata.

### Deleting a webhook

When you wish to remove a webhook, call its `destroy` method:

    webhook.destroy
