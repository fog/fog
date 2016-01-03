# Getting started: the compute service
The CloudAtCost UI is pretty terrible,its slow and it stops working most of the time.Moreover you cannot customize the machines.This is where the fog comes to play.

To use fog

You'll need a CloudAtCost account and an API token to use this provider.

Get one from https://panel.cloudatcost.com.

Click on the settings button in menu.
Make sure you add your ip to the allowed ip field.

Write down the API Token.

## Connecting, retrieving and managing server objects

First, create a connection to the host:

```ruby
require 'fog'

cac = Fog::Compute.new({
  :provider  => 'CloudAtCost',
  :email     => 'example@email.com', # Your email address
  :api_key   => 'poiuweoruwoeiuroiwuer', # your API Token   
})
```

## Listing servers

Listing servers and attributes:

```ruby
cac do |server|
  puts server.ip
  puts server.servername
  puts server.vmname
  puts server.mode
  puts server.label
end
```

## Server creation and life-cycle management

Creating a new server :

```ruby
server = cac.servers.create :cpu => 'foobar', # 1, 2, 4 
                            :ram  => 1024, # multiple of 4 min 512
                            :storage => 10, # 10G
                            :template_id => 75 #Template id
```

The server is automatically started after that.

As you can see you need the template_id to create the server:

```ruby
cac.templates.each do |image|
  puts image.id
  puts image.detail
end
```

Power off a server:

```ruby
server = cac.servers.first
server.power_off
```

Power on a server:

```ruby
server.power_on
```

Destroying the server:

```ruby
server.destroy
```
