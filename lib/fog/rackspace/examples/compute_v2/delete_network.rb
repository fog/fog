#!/usr/bin/env ruby

# This example demonstrates deletes a private network and attaching it to a new server with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def wait_for_server_deletion(server)
  begin
    server.wait_for { state = 'DELETED' }
  rescue Fog::Compute::RackspaceV2::NotFound => e
    # do nothing
  end
end

# I have notice that cloud networks is slow to acknowledge deleted servers. This method tries to mitigate this.
def delete_network(network)
  attempt = 0
  begin
    network.destroy
  rescue Fog::Compute::RackspaceV2::ServiceError => e
    if attempt == 3
       puts  "Unable to delete #{network.label}"
      return false
    end
     puts "Network #{network.label} Delete Fail Attempt #{attempt}- #{e.inspect}"
    attempt += 1
    sleep 60
    retry
  end
  return true
end

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

# Use username defined in ~/.fog file, if absent prompt for username.
# For more details on ~/.fog refer to http://fog.io/about/getting_started.html
def rackspace_username
  Fog.credentials[:rackspace_username] || get_user_input("Enter Rackspace Username")
end

# Use api key defined in ~/.fog file, if absent prompt for api key
# For more details on ~/.fog refer to http://fog.io/about/getting_started.html
def rackspace_api_key
  Fog.credentials[:rackspace_api_key] || get_user_input("Enter Rackspace API key")
end

# create Next Generation Cloud Server service
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => :ord #Use Chicago Region
})

# NOTE: The network must not be connected to any servers before deletion

# Find alpha bits server
server = service.servers.find {|s| s.name == 'alphabits'}

puts "\n"
if server
  puts "Deleting alphabits server..."
  server.destroy
else
  puts "Unable to find server alphabits"
end

wait_for_server_deletion(server)

network = service.networks.find {|n| n.label == 'my_private_net'}
delete_network(network)

puts "The network '#{network.label}' has been successfully deleted"
