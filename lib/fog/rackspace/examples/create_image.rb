#!/usr/bin/env ruby

# This example demonstrates creating a server image with the Rackpace Open Cloud

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

abort "\nThere are not any servers avaliable to image. Try running create_server.rb\n\n" if servers.empty?

puts "\nSelect server image:\n\n"
servers.each_with_index do |server, i|
  puts "\t #{i}. #{server.name} [#{server.public_ip_address}]"
end

selected_str = get_user_input "\nEnter number"

selected_id = begin
  Integer(selected_str)
rescue
  abort "Unrecognized input. Exiting without creating image."
end

server = servers[selected_id]
image_name = get_user_input "Enter name for image"

#creates image for server
server.create_image image_name
  
puts "\n\nImage #{image_name} is being created for server #{server.name}.\n\n"

puts "To delete the image please execute the delete_image.rb script\n\n"


