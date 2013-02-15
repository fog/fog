![fog](http://geemus.s3.amazonaws.com/fog.png)

fog is the Ruby cloud services library, top to bottom:

* Collections provide a simplified interface, making clouds easier to work with and switch between.
* Requests allow power users to get the most out of the features of each individual cloud.
* Mocks make testing and integrating a breeze.

[![Build Status](https://secure.travis-ci.org/fog/fog.png?branch=master)](http://travis-ci.org/fog/fog)
[![Gem Version](https://fury-badge.herokuapp.com/rb/fog.png)](http://badge.fury.io/rb/fog)
[![Dependency Status](https://gemnasium.com/fog/fog.png)](https://gemnasium.com/fog/fog)
[![Code Climate](https://codeclimate.com/github/fog/fog.png)](https://codeclimate.com/github/fog/fog)

## Getting Started

    sudo gem install fog

Now type `fog` to try stuff, confident that fog will let you know what to do. 
Here is an example of wading through server creation for Amazon Elastic Compute Cloud:

    >> server = Compute[:aws].servers.create
    ArgumentError: image_id is required for this operation

    >> server = Compute[:aws].servers.create(:image_id => 'ami-5ee70037')
    <Fog::AWS::EC2::Server [...]>

    >> server.destroy # cleanup after yourself or regret it, trust me
    true

## Collections

A high level interface to each cloud is provided through collections, such as `images` and `servers`.
You can see a list of available collections by calling `collections` on the connection object. 
You can try it out using the `fog` command:

    >> Compute[:aws].collections
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

    compute = Fog::Compute.new(
      :provider           => 'Rackspace',
      :rackspace_api_key  => key,
      :rackspace_username => username
    )

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

## Mocks

As you might imagine, testing code using Fog can be slow and expensive, constantly turning on and and shutting down instances.
Mocking allows skipping this overhead by providing an in memory representation resources as you make requests.
Enabling mocking easy to use, before you run other commands, simply run:

    Fog.mock!

Then proceed as usual, if you run into unimplemented mocks, fog will raise an error and as always contributions are welcome!

## Requests

Requests allow you to dive deeper when the models just can't cut it.
You can see a list of available requests by calling `#requests` on the connection object.

For instance, ec2 provides methods related to reserved instances that don't have any models (yet). Here is how you can lookup your reserved instances:

    $ fog
    >> Compute[:aws].describe_reserved_instances
    #<Excon::Response [...]>

It will return an [excon](http://github.com/geemus/excon) response, which has `body`, `headers` and `status`. Both return nice hashes.

## Go forth and conquer

Play around and use the console to explore or check out [fog.io](http://fog.io) for more details and examples. 
Once you are ready to start scripting fog, here is a quick hint on how to make connections without the command line thing to help you.

    # create a compute connection
    compute = Fog::Compute.new(:provider => 'AWS', :aws_access_key_id => ACCESS_KEY_ID, :aws_secret_access_key => SECRET_ACCESS_KEY)
    # compute operations go here

    # create a storage connection
    storage = Fog::Storage.new(:provider => 'AWS', :aws_access_key_id => ACCESS_KEY_ID, :aws_secret_access_key => SECRET_ACCESS_KEY)
    # storage operations go here

geemus says: "That should give you everything you need to get started, but let me know if there is anything I can do to help!"

## Contributing

* Find something you would like to work on.
  * Look for anything you can help with in the [issue tracker](https://github.com/fog/fog/issues).
  * Look at the [code quality metrics](https://codeclimate.com/github/fog/fog) for anything you can help clean up.
  * Or anything else!
* Fork the project and do your work in a topic branch.
  * Make sure your changes will work on both Ruby 1.8.7 and Ruby 1.9
* Add a config at `tests/.fog` for the component you want to test.
* Add shindo tests to prove your code works and run all the tests using `bundle exec rake`.
* Rebase your branch against `fog/fog` to make sure everything is up to date.
* Commit your changes and send a pull request.

## Additional Resources

[fog.io](http://fog.io)

## Copyright

(The MIT License)

Copyright (c) 2013 [geemus (Wesley Beary)](http://github.com/geemus)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
