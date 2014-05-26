#!/usr/bin/env ruby

# This example demonstrates creating a snapshot from a Cloud Block Storage volume with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "\n#{prompt}: "
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

#create Cloud Block Storage service
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

# prompt for snapshot name
snapshot_name = get_user_input "Enter Snapshot Name"

puts "\n\n"
puts "******************** NOTE ******************************************"
puts "* Volume must be unmounted from operating system before detaching. *"
puts "* This script assumes volume has been unmounted.                   *"
puts "********************************************************************\n\n"

volume = cbs_service.volumes.get attachment.volume_id

# The snapshot process requires all writes to be flushed to disk. This requires unmounting the file systems or detaching the volume.
puts "Detaching Volume #{volume.display_name}"
attachment.detach

volume.wait_for { ready? }

puts "Now Creating Snapshot #{snapshot_name}"
snapshot = cbs_service.snapshots.create :display_name => snapshot_name, :volume_id => attachment.volume_id

begin
  # Check every 5 seconds to see if snapshot is in the available state (ready?).
  # If the available has not been built in 5 minutes (600 seconds) an exception will be raised.
  snapshot.wait_for(600, 5) do
    print "."
    STDOUT.flush
    ready?
  end

  puts "[DONE]\n\n"

  puts "Re-attaching Volume #{volume.display_name}"
  attachment.save

rescue Fog::Errors::TimeoutError
  puts "[TIMEOUT]\n\n"

  puts "The snapshot #{snapshot.display_name} is still being preformed and is taking longer to complete than expected."
  puts "You can continute to monitor the process through the web console at https://mycloud.rackspace.com/\n\n"
end
