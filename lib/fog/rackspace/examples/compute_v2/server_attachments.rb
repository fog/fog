#!/usr/bin/env ruby

# This example demonstrates working with server and volumes on the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

def select_server(servers)
  abort "\nThere are not any servers in the Chicago region. Try running create_server.rb\n\n" if servers.empty?

  puts "\nSelect Server For Attachment:\n\n"
  servers.each_with_index do |server, i|
    puts "\t #{i}. #{server.name} [#{server.public_ip_address}]"
  end

  delete_str = get_user_input "\nEnter Server Number"
  servers[delete_str.to_i]
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

#create Next Generation Cloud Server service
compute_service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => :ord #Use Chicago Region
})

cbs_service = Fog::Rackspace::BlockStorage.new({
  :rackspace_username => rackspace_username,
  :rackspace_api_key  => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
})

# retrieve list of servers
servers = compute_service.servers

# prompt user for server
server = select_server(servers)

# prompt for volume name
volume_name = get_user_input "Enter Volume Name"

puts "\nCreating Volume\n"
volume = cbs_service.volumes.create(:size => 100, :display_name => volume_name)

puts "\nAttaching volume\n"
attachment = server.attach_volume volume

puts "\nVolume #{volume.display_name} has been attached to #{server.name} on device #{attachment.device}\n\n"
puts "To detach volume please execute the detach_volume.rb script\n\n"
