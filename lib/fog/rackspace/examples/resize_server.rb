#!/usr/bin/env ruby

# This example demonstrates how to resize servers with Fog and the Rackspace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require './lib/fog'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

# Use username defined in ~/.fog file, if absent prompt for username. 
# For more details on ~/.fog refer to http://fog.io/about/getting_started.html
def rackspace_username
  username = Fog.credentials[:rackspace_username]
  username ||= get_user_input "Enter Rackspace Username: "
end

# Use api key defined in ~/.fog file, if absent prompt for api key
# For more details on ~/.fog refer to http://fog.io/about/getting_started.html
def rackspace_api_key
  api_key = Fog.credentials[:rackspace_api_key]
  api_key ||= get_user_input "Enter Rackspace API key: "
end

#create Next Generation Cloud Server service
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_endpoint => Fog::Compute::RackspaceV2::ORD_ENDPOINT #Use Chicago Region
})

#retrieve list of servers
servers = service.servers

abort "\nThere are not any servers to resize. Try running create_server.rb\n\n" if servers.empty?

puts "\nSelect server resize:\n\n"
servers.each_with_index do |server, i|
  puts "\t #{i}. #{server.name} [#{server.public_ip_address}]"
end

selected_str = get_user_input "\nEnter number"
server = servers[selected_str.to_i]

puts "\n"

# retrieve list of avaliable flavors
flavors = service.flavors

puts "\nSelect flavor to resize to:\n\n"
flavors.each_with_index do |flavor, i|
  next if server.flavor_id == flavor.id
  puts "\t #{i}. #{flavor.name}"
end

selected_flavor_str = get_user_input "\nEnter number"
selected_flavor = flavors[selected_flavor_str.to_i]

# resize server
server.resize selected_flavor.id

begin
  # Check every 5 seconds to see if server is in the active state (ready?). 
  # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
  server.wait_for(600, 5) do
    print "."
    STDOUT.flush
    ready?
  end

  puts "[DONE]\n\n"
rescue Fog::Errors::TimeoutError
  puts "[TIMEOUT]\n\n"
  
  puts "This server is currently #{server.progress}% into the resize process and is taking longer to complete than expected."
  puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n" 

  exit
end

  puts "Server has been successfull resized!"
  action = get_user_input "Press 'C' to confirm or 'R' to revert resize (R/C)"

  case action
  when 'C'
    puts "\nConfirming resize operation"
    server.confirm_resize
  when 'R'
    puts "\nReverting resize operation"
    server.revert_resize
  else
    puts "\nUnrecognized input. Exiting."
  end
