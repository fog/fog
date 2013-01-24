#!/usr/bin/env ruby

# This example demonstrates creating a server with the Rackpace Open Cloud
require 'rubygems' #required for Ruby 1.8.x
require './lib/fog'

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

def print_metadata(server)
  server.metadata.each do |metadatum|
    puts "#{metadatum.key}: #{metadatum.value}"
  end
  puts "\n"
end

#create Next Generation Cloud Server service
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_endpoint => Fog::Compute::RackspaceV2::ORD_ENDPOINT #Use Chicago Region
})

# Pick the first flavor
flavor = service.flavors.first

# Pick the first Ubuntu image we can find
image = service.images.find {|image| image.name =~ /Ubuntu/}

# create server
server = service.servers.create :name => 'cumulus', 
                                :flavor_id => flavor.id, 
                                :image_id => image.id,
                                :metadata => { 'color' => 'red'}

puts "metadata from server creation"                                
print_metadata(server)

puts "adding new metadata\n"
server.metadata["environment"] = "demo"

puts "updating existing metadata\n"
server.metadata["color"] = "blue"

puts "saving latest metadata change\n"
server.metadata.save

puts "reload latest server metadata"
server.metadata.reload

print_metadata(server)

puts "delete environment metadata"
metadatum = server.metadata.find {|metadataum| metadataum.key == 'environment'}
metadatum.destroy

puts "reload latest server metadata"
server.metadata.reload

puts "To delete the server please execute the delete_server.rb script\n\n"




