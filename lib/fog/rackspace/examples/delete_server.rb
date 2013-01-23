#!/usr/bin/env ruby

# This example demonstrates how to delete servers with Fog and the Rackspace Open Cloud

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

abort "\nThere are not any servers to delete. Try running create_server.rb\n\n" if servers.empty?

puts "\nSelect server delete:\n\n"
servers.each_with_index do |server, i|
  puts "\t #{i}. #{server.name} [#{server.public_ip_address}]"
end

delete_str = get_user_input "\nEnter number (type 'ALL' to delete all servers)"
abort "Unrecognized input. Exiting without deleting servers." unless delete_str =~ /^ALL|\d+$/

confirm = get_user_input "Are you sure? (Y/N)"
abort "Exiting without deleting servers" unless confirm == 'Y'

puts "\n\n"

if delete_str == 'ALL'
  servers.each {|server| server.destroy }
  puts "All servers have been destroyed"
else
  delete_id = Integer(delete_str)
  server = servers[delete_id]
  server.destroy
  puts "#{server.name} has been destroyed"
end

