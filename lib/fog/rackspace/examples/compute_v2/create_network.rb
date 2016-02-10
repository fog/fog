#!/usr/bin/env ruby

# This example demonstrates creating a private network and attaching it to a new server with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

# UUID for INTERNET
INTERNET = '00000000-0000-0000-0000-000000000000'

# UUID for Rackspace's service net
SERVICE_NET = '11111111-1111-1111-1111-111111111111'

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

#create private network called my_private_net with an ip range between 192.168.0.1 - 192.168.0.255 (Note this will accept IPv6 CIDRs as well)
net = service.networks.create :label => 'my_private_net', :cidr => '192.168.0.0/24'

puts "\nCreating #{net.label} Network with CIDR #{net.cidr}"

# pick the first flavor
flavor = service.flavors.first

# pick the first Ubuntu image we can find
image = service.images.find {|image| image.name =~ /Ubuntu/}

# Create a server called alphabits connected our private network as well as the internet
server = service.servers.create :name => 'alphabits',
                                :flavor_id => flavor.id,
                                :image_id => image.id,
                                :networks => [net.id, INTERNET]

puts "\nNow creating server '#{server.name}' connected the the Internet and '#{net.label}'\n"

begin
  # Check every 5 seconds to see if server is in the active state (ready?).
  # If the server has not been built in 10 minutes (600 seconds) an exception will be raised.
  server.wait_for(600, 5) do
    print "."
    STDOUT.flush
    ready?
  end

  puts "[DONE]\n\n"

  puts "The server has been successfully created, to login onto the server:\n\n"
  puts "\t ssh #{server.username}@#{server.public_ip_address}\n\n"

rescue Fog::Errors::TimeoutError
  puts "[TIMEOUT]\n\n"

  puts "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
  puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
end

puts "The #{server.username} password is #{server.password}\n\n"
puts "To delete the server and private network please execute the delete_network.rb script\n\n"
