---
layout: default
title:  Structure
---

fog is the Ruby cloud computing library, top to bottom:

* Collections provide a simplified interface, making clouds easier to work with and switch between.
* Requests allow power users to get the most out of the features of each individual cloud.
* Mocks make testing and integrating a breeze.
                                               
## Collections

A high level interface to each cloud is provided through collections, such as `images` and `servers`.
You can see a list of available collections by calling `collections` on the connection object. You can try it out using the `fog` command:

    >> AWS.collections
    [:addresses, :directories, ..., :volumes, :zones]

Some collections are available across multiple providers:

* compute providers have `flavors`, `images` and `servers`
* dns providers have `zones` and `records`
* storage providers have `directories` and `files`

Collections share basic CRUD type operations, such as:
* `all` - fetch every object of that type from the provider.
* `create` - initialize a new record locally and a remote resource with the provider.
* `get` - fetch a single object by it's identity from the provider.
* `new` - initialize a new record locally, but do not create a remote resource with the provider.

As an example, we'll try initializing and persisting a Rackspace Cloud server:

    require 'fog'

    compute = Fog::Compute.new({
      :provider           => 'Rackspace',
      :rackspace_api_key  => key,
      :rackspace_username => username
    })

    # boot a gentoo server (flavor 1 = 256, image 3 = gentoo 2008.0)
    server = compute.servers.create(:flavor_id => 1, :image_id => 3, :name => 'my_server')
    server.wait_for { ready? } # give server time to boot

    # DO STUFF

    server.destroy # cleanup after yourself or regret it, trust me

## Models

Many of the collection methods return individual objects, which also provide common methods:
* `destroy` - will destroy the persisted object from the provider
* `save` - persist the object to the provider
* `wait_for` - takes a block and waits for either the block to return true for the object or for a timeout (defaults to 10 minutes)

## Requests

Requests allow you to dive deeper when the models just can't cut it.
You can see a list of available requests by calling #requests on the connection object.

For instance, ec2 provides methods related to reserved instances that don't have any models (yet). Here is how you can lookup your reserved instances:

    $ fog
    >> AWS[:ec2].describe_reserved_instances
    #<Excon::Response [...]>

It will return an [excon](http://github.com/geemus/excon) response, which has `body`, `headers` and `status`. Both return nice hashes.

## Mocks

As you might imagine, testing code using Fog can be slow and expensive, constantly turning on and and shutting down instances.
Mocking allows skipping this overhead by providing an in memory representation resources as you make requests.
Enabling mocking easy to use, before you run other commands, simply run:

    Fog.mock!

Then proceed as usual, if you run into unimplemented mocks fog will raise an error and as always contributions are welcome!
