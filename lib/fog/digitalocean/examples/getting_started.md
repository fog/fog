# Getting started: the compute service

You'll need a DigitalOcean account and API key to use this provider.

Get one from http://www.digitalocean.com.

To generate the API key, login to the DigitalOcean web panel and go to 
'My Settings -> API Access -> Generate a new API key'.

Write down the Client Key and API Key, you'll need both to use the service.


## Connecting, retrieving and managing server objects

Before we start, I guess it will be useful to the reader to know
that Fog servers are 'droplets' in DigitalOcean's parlance. 
'Server' is the Fog way to name VMs, and we have
respected that in the DigitalOcean's Fog provider.

First, create a connection to the host:

```ruby
require 'fog'

docean = Fog::Compute.new({
  :provider => 'DigitalOcean',
  :digitalocean_api_key   => 'poiuweoruwoeiuroiwuer', # your API key here
  :digitalocean_client_id => 'lkjasoidfuoiu'          # your client key here
})
```

## Listing servers

Listing servers and attributes:

```ruby
docean.servers.each do |server|
  # remember, servers are droplets
  server.id
  server.name
  server.state
  server.backups_enabled
  server.image_id
  server.flavor_id # server 'size' in DigitalOcean's API parlance
  server.region_id
end
```

## Server creation and life-cycle management

Creating a new server (droplet):

```ruby
server = docean.servers.create :name => 'foobar',
                               # use the first image listed
                               :image_id  => docean.images.first.id,
                               # use the first flavor listed
                               :flavor_id => docean.flavors.first.id,
                               # use the first region listed 
                               :region_id => docean.regions.first.id
```

The server is automatically started after that.

We didn't pay attention when choosing the flavor, image and region used
but you can easily list them too, and then decide:

```ruby
docean.images.each do |image|
  image.id
  image.name
  image.distribution
end

docean.flavors.each do |flavor|
  flavor.id
  flavor.name
end

docean.regions.each do |region|
  region.id
  region.name
end

```

Rebooting a server:

```ruby
server = docean.servers.first
server.reboot
```

Power cycle a server:

```ruby
server.power_cycle
```

Destroying the server:

```ruby
server.destroy
```


