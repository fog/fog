# Getting started with Fog::Compute and Azure (2014/11/21)

You'll need a [ Management Portal](https://manage.windowsazure.com/) account and API key
to use this.

See http://msdn.microsoft.com/en-us/library/azure/ee460799.aspx.


## Setting credentials

Fog uses `~/.fog` to store credentials. To add Azure as your default provider, simply add the following:

    :default:
      :azure_sub_id: subscription id
      :azure_pem: path-to-certificate

## Connecting, retrieving and managing server objects

```ruby
require 'fog'
require 'pp'

azure = Fog::Compute.new(
  :provider => 'Azure',
  :azure_sub_id => '35a2461c-22ac-1111-5ed2-11165d755ba4',
  :azure_pem =>    'c:/path/abc.pem',
  :azure_api_url => 'usnorth.management.core.windows.net'
)
```

## Listing servers

Listing servers and attributes:

```ruby
azure.servers.each do |server|
  server.cloud_service_name
  server.vm_name
  server.status
  server.ipaddress
  server.image
  server.disk_name
  server.os_type
end
```

## Server creation and life-cycle management

Creating a new server:

```ruby
server = azure.servers.create(
    :image  => '604889f8753c3__OpenLogic-CentOS',
    :location => 'West US',
    :vm_name => 'fog-server',
    :vm_user => "foguser",
    :password =>  "ComplexPassword!123",
    :storage_account_name => 'fogstorage'
)
```


## Retrieve a single record

Get a single server record:

```ruby
server = azure.servers.get('vm-name')
server.cloud_service_name
server.vm_name
server.status
server.ipaddress
server.image
server.disk_name
server.os_type
```

Rebooting a server:

```ruby
server.reboot
```

Start a server:

```ruby
server.start
```

Shutdown a server:

```ruby
server.shutdown
```

Destroying the server:

```ruby
server.destroy
```
