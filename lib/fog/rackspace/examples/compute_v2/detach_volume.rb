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

  puts "\nSelect Server For Volume Detachment:\n\n"
  servers.each_with_index do |server, i|
    puts "\t #{i}. #{server.name} [#{server.public_ip_address}]"
  end

  delete_str = get_user_input "\nEnter Server Number"
  servers[delete_str.to_i]
end

def select_attachment(attachments)
  abort "\nThis server does not contain any volumes in the Chicago region. Try running server_attachments.rb\n\n" if attachments.empty?

  puts "\nSelect Volume To Detach:\n\n"
  attachments.each_with_index do |attachment, i|
    puts "\t #{i}. #{attachment.device}"
  end

  delete_str = get_user_input "\nEnter Volume Number"
  attachments[delete_str.to_i]
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

# get attached volumes --also know as attachments
attachments = server.attachments

# prompt user for volume to detach
attachment = select_attachment(attachments)

volume = cbs_service.volumes.get attachment.volume_id
puts "Detaching Volume #{volume.display_name} From Server #{server.name}"
attachment.detach

puts "\n"
delete_confirm = get_user_input "Would You Like To Destroy Volume #{volume.display_name} (y/n)"
if delete_confirm.downcase ==  'y'
  # wait for server to finish detaching before attempting to delete
  volume.wait_for(600)  do
    print "."
    STDOUT.flush
    ready? && attachments.empty?
  end

  volume.destroy

  puts "\n\nThe Volume Has been Destroyed"
end
