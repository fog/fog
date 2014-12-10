#!/usr/bin/env ruby

# This example demonstrates creating a server image with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

def select_server(servers)
  abort "\nThere are not any servers available to image in the Chicago region. Try running create_server.rb\n\n" if servers.empty?

  puts "\nSelect Server To Image:\n\n"
  servers.each_with_index do |server, i|
    puts "\t #{i}. #{server.name} [#{server.public_ip_address}]"
  end

  selected_str = get_user_input "\nEnter Server Number"
  servers[selected_str.to_i]
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

# retrieve list of servers
servers = service.servers

# prompt user for server
server = select_server(servers)

# prompt user for image name
image_name = get_user_input "Enter Image Name"

# creates image for server
server.create_image image_name

puts "\nImage #{image_name} is being created for server #{server.name}.\n\n"
puts "To delete the image please execute the delete_image.rb script\n\n"
