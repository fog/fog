# Getting started with OpenNebula (one) Fog provider

[OpenNebula](http://www.opennebula.org) provides ruby bindings to access the xml-rpc

The opennebula fog extensions provides examples for using Fog with OpenNebula (4.4).

**Note:** This provider is under construction! This means everything that is provided should work without problems, but there are many features not available yet. Please contribute!

## Requirements

For working with this provider the following pre-requisites are needed:

* Ruby version 1.8.x or 1.9.x
* `fog` gem
* Working OpenNebula instance with XML-RPC and credentials
* This version is tested with OpenNebula 4.4 and the opennebula gem dependency is hardcoded to this version. it should work with version 4.6, but is not tested.


## Examples

General proceeding:

* Connect to one-rpc
* create new vm object
* fetch a template/flavor from one (this template should be predefined)
* assigne the flavor/template to the vm
* change the attributes of this flavor/template (name, cpu, memory, nics....)
* save/instantiate the vm

```ruby
require 'fog'

# connect to your one rpc
con = Fog::Compute.new(
    {
      :provider => 'OpenNebula',
      :opennebula_username => 'user',
      :opennebula_password => 'password',
      :opennebula_endpoint => 'http://oned.domain:2633/RPC2'
    }
  )


# list all vms
con.servers

# list all flavors (templates in OpenNebula slang)
con.flavors

# get flavor with id 4
con.flavors.get 4

# list all Virtual Networks
con.networks
con.networks.get 2

# get all usergroups
con.groups

# create a new vm (creates the object, the vm is not instantiated yet)
newvm = con.servers.new

# set the flavor of the vm
newvm.flavor = con.flavors.get 4

# set the name of the vm
newvm.name = "FooBarVM"

# set the groupid of the vm 
newvm.gid = 0

# set cores and memory (MB)
newvm.flavor.vcpu = 2
newvm.flavor.memory = 256

# create a new network interface attached to the network with id 1 and virtio as driver/model
network = client.networks.get(1)
nic = con.interfaces.new({ :vnet => network, :model => "virtio"})

# Attach the new nic to our vm
newvm.flavor.nic = [ nic ]

# instantiat the new vm
newvm.save
```

## Features

tbd

## not working yet

* con.groups.get 4

_AND_ everything not mentioned in features or examples ;)


## Troubleshooting

* ArgumentError: opennebula is not a recognized compute provider
  * is the correct gem version included?

## Additional Resources
* [Fog cloud library](http://fog.io)
* [Fog documentation](http://rubydoc.info/gems/fog)
* [Fog Github repo](https://github.com/fog/fog)
* [Fog Release Notes](https://github.com/fog/fog/blob/master/changelog.txt)
* [Ruby OpenNebula Cloud API](http://docs.opennebula.org/stable/integration/system_interfaces/ruby.html)
* [OpenNebula ruby bindings](http://docs.opennebula.org/doc/stable/oca/ruby/)

## Support and Feedback

Please contribute and send feedback! Just do it here!
