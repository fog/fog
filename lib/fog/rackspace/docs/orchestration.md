# OpenStack Orchestration
The mission of the OpenStack Orchestration program is to create a human- and machine-accessible service for managing the entire lifecycle of infrastructure and applications within OpenStack clouds.

## Heat
Heat is the main project in the OpenStack Orchestration program. It implements an orchestration engine to launch multiple composite cloud applications based on templates in the form of text files that can be treated like code. A native Heat template format is evolving, but Heat also endeavours to provide compatibility with the AWS CloudFormation template format, so that many existing CloudFormation templates can be launched on OpenStack. Heat provides both an OpenStack-native ReST API and a CloudFormation-compatible Query API.

*Why ‘Heat’? It makes the clouds rise!*

**How it works**

* A Heat template describes the infrastructure for a cloud application in a text file that is readable and writable by humans, and can be checked into version control, diffed, &c.
* Infrastructure resources that can be described include: servers, floating ips, volumes, security groups, users, etc.
* Heat also provides an autoscaling service that integrates with Ceilometer, so you can include a scaling group as a resource in a template.
* Templates can also specify the relationships between resources (e.g. this volume is connected to this server). This enables Heat to call out to the OpenStack APIs to create all of your infrastructure in the correct order to completely launch your application.
* Heat manages the whole lifecycle of the application - when you need to change your infrastructure, simply modify the template and use it to update your existing stack. Heat knows how to make the necessary changes. It will delete all of the resources when you are finished with the application, too.
* Heat primarily manages infrastructure, but the templates integrate well with software configuration management tools such as Puppet and Chef. The Heat team is working on providing even better integration between infrastructure and software.

_Source: [OpenStack Wiki](https://wiki.openstack.org/wiki/Heat)_

# Rackspace Orchestration (Heat) Client

[Full Rackspace Orchestration/Heat API Docs](http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/API_Operations_dle7023.html)

## Orchestration Service
Get a handle on the Orchestration service:

```ruby
irb: service = Fog::Rackspace::Orchestration.new({
	:rackspace_username => username,
	:rackspace_api_key  => api_key,
  	:rackspace_region   => :iad #:ord, :dfw, :syd
})
===> #<Fog::Rackspace::Orchestration::Real:2168274880 ...
```
We will use this `service` to interact with the Orchestration resources, `stack`, `event`,  `resource`, and `template`

## Stacks

Get a list of stacks you own:

```ruby
irb: service.stacks
===>   <Fog::Rackspace::Orchestration::Stacks
    []
  >
```

Create a new `stack` with a [Heat Template (HOT)](http://docs.openstack.org/developer/heat/template_guide/hot_guide.html). Here we are using Rackspace's HOT for [a single redis server]("https://github.com/rackspace-orchestration-templates/redis-single/blob/master/redis-single.yaml"):

```ruby
redis_template = File.read("spec/support/redis_template.yml")
===> "heat_template_version: 2013-05-23\n\ndescription: ....

irb:  service.stacks.new.save({
		:stack_name => "a_redis_stack",
		:template   => redis_template
	})
```

We get back a JSON blob filled with info about our new stack:

```ruby
===> {"id"=>"73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "links"=>[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"self"}]}
```

Now that we have the `id` of our new stack, we can get a reference to it using the stack's `name` and `id`:


```ruby
irb: stack = service.stacks.get("a_redis_stack", "73e0f38a-a9fb-4a4e-8196-2b63039ef31f")
===>   <Fog::Rackspace::Orchestration::Stack
    id="73e0f38a-a9fb-4a4e-8196-2b63039ef31f",
    description="This is a Heat template to deploy a standalone redis server on\nRackspace Cloud Servers\n",
    links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"self"}],
    stack_status_reason="Stack CREATE started",
    stack_name="a_redis_stack",
    creation_time="2014-11-13T16:21:02Z",
    updated_time=nil
  >
```
A stack knows about related `events`:

```ruby
irb: stack.events
===>   <Fog::Rackspace::Orchestration::Events
    [
      <Fog::Rackspace::Orchestration::Event
        id="7b1830a3-5d7b-43b2-bc1b-cffbb25c8b3e",
        resource_name="redis_server_config",
        event_time="2014-11-13T16:21:45Z",
        links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server_config/events/7b1830a3-5d7b-43b2-bc1b-cffbb25c8b3e", "rel"=>"self"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server_config", "rel"=>"resource"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"stack"}],
        logical_resource_id="redis_server_config",
        resource_status="CREATE_IN_PROGRESS",
        resource_status_reason="state changed",
        physical_resource_id=nil
      >,
```
A stack knows about related `resources`:

```ruby
irb: stack.resources
===>   <Fog::Rackspace::Orchestration::Resources
    [
      <Fog::Rackspace::Orchestration::Resource
        id=nil,
        resource_name="redis_server",
        description=nil,
        links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server", "rel"=>"self"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"stack"}],
        logical_resource_id="redis_server",
        resource_status="CREATE_COMPLETE",
        updated_time="2014-11-13T16:21:04Z",
        required_by=["redis_server_config"],
        resource_status_reason="state changed",
        resource_type="Rackspace::Cloud::Server"
      >,
```

You can list, limit, sort stacks based on certain keywords:

** Available keywords:**

* status
* ​name
* ​limit
* ​marker
* ​sort_keys
* sort_dir

```ruby
irb:  stacks = service.stacks.all(sort_key: "stack_name", sort_dir: "asc")
===>   <Fog::Rackspace::Orchestration::Stacks
    [
      <Fog::Rackspace::Orchestration::Stack
        id="73e0f38a-a9fb-4a4e-8196-2b63039ef31f",
        description="This is a Heat template to deploy a standalone redis server on\nRackspace Cloud Servers\n",
        links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"self"}],
        stack_status_reason="Stack CREATE started",
        stack_name="a_redis_stack",
        creation_time="2014-11-13T16:21:02Z",
        updated_time=nil
      >
    ]
  >
```
You can get a stack's `template`

```ruby
irb: stack.template
===>   <Fog::Rackspace::Orchestration::Template
    description="This is a Heat template to deploy a standalone redis server on\nRackspace Cloud Servers\n",
    heat_template_version="2013-05-23",
    ....
```
You can abandon a stack -- essentially, it will delete the stack, but keep the resources around for potential further use:

```ruby
irb: stack.abandon
===> #<Excon::Response:0x00000104d6b870 @data={:body=>{"status"=>"IN_PROGRESS", "name"=>"a_redis_stack", "stack_user_project_id"=>"930035", "environment"=>{"parameters"=>{}, "resource_registry"=>{"resources"=>{}}}, "template"=>{"parameter_groups"=>[{"parameters"=>["flavor", "image"], "label"=>"Server Settings"}, {"parameters"=>["redis_port"], "label"=>"Redis Settings"}, {"parameters"=>["redis_version", "redis_hostname", "kitchen", "chef_version"], "label"=>"rax-dev-params"}], "heat_template_version"=>"2013-05-23", "description"=>"This is a Heat te
```

You can preview a stack:

```ruby
irb: service.stacks.preview({
		:stack_name => "a_redis_template",
		:template   => redis_template
	})
===>   <Fog::Rackspace::Orchestration::Stack
    id="None",
    description="This is a Heat template to deploy a standalone redis server on\nRackspace Cloud Servers\n",
    links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_template/None", "rel"=>"self"}],
    stack_status_reason=nil,
    stack_name="a_redis_template",
    creation_time="2014-11-13T16:33:50Z",
    updated_time=nil
  >
```

Of course, you can just delete a stack. This deletes associated `resources` (as opposed to `abandon`):

```ruby
irb: stack.delete
===> #<Excon::Response:0x0000010198b000 @data={:body=>"", :headers=>{"Server"=>"nginx/1.2.1", "Date"=>"Thu, 13 Nov 2014 16:28:38 GMT", "Content-Type"=>"text/html; charset=UTF-8", "Connection"=>"keep-alive", "Via"=>"1.0 Repose (Repose/6.0.2)"}, :status=>204, :reason_phrase=>"No Content", :remote_ip=>"23.253.147.138", :local_port=>54721, :local_address=>"192.168.1.65"}, @body="", @headers={"Server"=>"nginx/1.2.1", "Date"=>"Thu, 13 Nov 2014 16:28:38 GMT", "Content-Type"=>"text/html; charset=UTF-8", "Connection"=>"keep-alive", "Via"=>"1.0 Repose (Repose/6.0.2)"}, @status=204, @remote_ip="23.253.147.138", @local_port=54721, @local_address="192.168.1.65">
```

Reload any object by calling `reload` on it:

```ruby
irb: stacks.reload
===>   <Fog::Rackspace::Orchestration::Stacks
    []
  >
```
You can get build information:

```ruby
irb: service.stacks.build_info
===> {"engine"=>{"revision"=>"2014.k1-20141027-1178"}, "fusion-api"=>{"revision"=>"j1-20140915-10d9ee4-98"}, "api"=>{"revision"=>"2014.k1-20141027-1178"}}
```

## Events

`Events` are indexable and can be scoped by `stack`:

```ruby
irb: event = stack.events.first
===>   <Fog::Rackspace::Orchestration::Event
    id="7b1830a3-5d7b-43b2-bc1b-cffbb25c8b3e",
    resource_name="redis_server_config",
    event_time="2014-11-13T16:21:45Z",
    links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server_config/events/7b1830a3-5d7b-43b2-bc1b-cffbb25c8b3e", "rel"=>"self"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server_config", "rel"=>"resource"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"stack"}],
    logical_resource_id="redis_server_config",
    resource_status="CREATE_IN_PROGRESS",
    resource_status_reason="state changed",
    physical_resource_id=nil
  >
```

`Events` can be sorted, limited, etc by passing an hash like so:
`service.events.all(stack, limit: 1)`

** Available keys: **

* resource_action
* resource_status
* resource_name
* ​resource_type
* ​limit
* ​marker
* sort_keys
* ​sort_dir

They are getable:

```ruby
irb: event = service.events.get(stack, resource, event_id)
===>   <Fog::Rackspace::Orchestration::Event
    id="7b1830a3-5d7b-43b2-bc1b-cffbb25c8b3e",
    resource_name="redis_server_config",
    event_time="2014-11-13T16:21:45Z",
    links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server_config/events/7b1830a3-5d7b-43b2-bc1b-cffbb25c8b3e", "rel"=>"self"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server_config", "rel"=>"resource"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"stack"}],
    logical_resource_id="redis_server_config",
    resource_status="CREATE_IN_PROGRESS",
    resource_status_reason="state changed",
    physical_resource_id=nil
  >
```

An `event` knows about its associated `stack`:

```ruby
irb: event.stack
===>   <Fog::Rackspace::Orchestration::Stack
    id="73e0f38a-a9fb-4a4e-8196-2b63039ef31f",
    description="This is a Heat template to deploy a standalone redis server on\nRackspace Cloud Servers\n",
    links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"self"}],
    stack_status_reason="Stack CREATE completed successfully",
    stack_name="a_redis_stack",
    creation_time="2014-11-13T16:21:02Z",
    updated_time=nil
  >
```

You can list, limit, sort events based on certain keywords:

```ruby
irb: events = stack.events.all(stack, sort_key: "resource_name", sort_dir: "desc", limit: 3)
===>   <Fog::Rackspace::Orchestration::Events
    [
      <Fog::Rackspace::Orchestration::Event
        id="9cdae7d7-f44e-4dbb-bc0b-61ea6da9cf81",
        resource_name="redis_server_config",
        event_time="2014-11-13T16:24:07Z",
        ....
```

An  `event` has an associated `resource`:

```ruby
irb: resource = event.resource
===>   <Fog::Rackspace::Orchestration::Resource
    id=nil,
    resource_name="redis_server_config",
    description="",
    links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f/resources/redis_server_config", "rel"=>"self"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"stack"}],
    logical_resource_id="redis_server_config",
    resource_status="CREATE_COMPLETE",
    updated_time="2014-11-13T16:21:45Z",
    required_by=[],
    resource_status_reason="state changed",
    resource_type="OS::Heat::ChefSolo"
  >
```

## Resource

`resources` are indexable:

```ruby
irb: service.resources.all(stack, {nested_depth: 1})
===>   <Fog::Rackspace::Orchestration::Resources
    [
      <Fog::Rackspace::Orchestration::Resource
        id=nil,
        resource_name="redis_server",
        description=nil,
        links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/ee648a3b-14a3-4df8-aa58-620a9d67e3e5/resources/redis_server", "rel"=>"self"}, {"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/ee648a3b-14a3-4df8-aa58-620a9d67e3e5", "rel"=>"stack"}],
        logical_resource_id="redis_server",
        resource_status="CREATE_COMPLETE",
        updated_time="2014-11-13T16:32:30Z",
        required_by=["redis_server_config"],
        resource_status_reason="state changed",
        resource_type="Rackspace::Cloud::Server"
      >,
      ...
```

A `resource` knows about its associated `stack`:

```ruby
irb: resource.stack
===>   <Fog::Rackspace::Orchestration::Stack
    id="73e0f38a-a9fb-4a4e-8196-2b63039ef31f",
    description="This is a Heat template to deploy a standalone redis server on\nRackspace Cloud Servers\n",
    links=[{"href"=>"https://iad.orchestration.api.rackspacecloud.com/v1/930035/stacks/a_redis_stack/73e0f38a-a9fb-4a4e-8196-2b63039ef31f", "rel"=>"self"}],
    stack_status_reason="Stack CREATE completed successfully",
    stack_name="a_redis_stack",
    creation_time="2014-11-13T16:21:02Z",
    updated_time=nil
  >
```

Resource metadata is visible:

```ruby
irb: resource.metadata
===> {}
```

A `resource's` template is visible (if one exists)

```ruby
irb: resource.template
===> nil
```

## Validation
You can validate a Heat template (HOT) before using it:

```ruby
irb: service.templates.validate({:template => redis_template})
===>   <Fog::Rackspace::Orchestration::Template
    description="This is a Heat template to deploy a standalone redis server on\nRackspace Cloud Servers\n",
    heat_template_version=nil,
    ...
```
