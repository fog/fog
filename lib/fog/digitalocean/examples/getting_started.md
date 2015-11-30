# Getting started: the compute service

You'll need a DigitalOcean account and an API token to use this provider.

Get one from https://cloud.digitalocean.com/settings/tokens/new

Write down the Access Token.

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
  :version  => 'V2',
  :digitalocean_token   => 'poiuweoruwoeiuroiwuer', # your Access Token here
})
```

## SSH Key Management

Access to DigitalOcean servers can be managed with SSH keys. These can be assigned to servers at creation time so you can access them without having to use a password.

Creating a key:

```ruby
docean.ssh_keys.create(
  :name        => 'Default SSH Key',
  :ssh_pub_key => File.read('~/.ssh/id_rsa.pub'))
)
```

Listing all keys:

```ruby
docean.ssh_keys.each do | key |
  puts key.name
  puts key.public_key
  puts key.id
end
```

Destroying a key:

```ruby
docean.ssh_keys.destroy(:id => '27100')
```
## Listing servers

Listing servers and attributes:

```ruby
docean.servers.each do |server|
  # remember, servers are droplets
  puts server.id
  puts server.name
  puts server.status
  puts (server.image['slug'] || server.image['name']) # slug is only for public images, private images use name
  puts server.size['slug']
  puts server.region['slug']
end
```

## Server creation and life-cycle management

Creating a new server (droplet):

```ruby
server = docean.servers.create :name => 'foobar',
                               # use the last image listed
                               :image  => docean.images.last.id,
                               # use the first flavor (aka size) listed
                               :size => docean.flavors.first.slug,
                               # use the first region listed
                               :region => docean.regions.first.slug
```

The server is automatically started after that.

We didn't pay attention when choosing the flavor, image and region used
but you can easily list them too, and then decide:

```ruby
docean.images.each do |image|
  puts image.id
  puts image.name
  puts image.distribution
end

docean.flavors.each do |flavor|
  puts flavor.slug
end

docean.regions.each do |region|
  puts region.slug
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
