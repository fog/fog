#!/usr/bin/env ruby

# This example demonstrates working with server metadata on the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require './lib/fog'

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

def print_metadata(server)
  server.metadata.each do |metadatum|
    puts "\t#{metadatum.key}: #{metadatum.value}"
  end
  puts "\n"
end

#create Next Generation Cloud Server service
service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => :ord #Use Chicago Region
})

# Pick the first flavor
flavor = service.flavors.first

# Pick the first Ubuntu image we can find
image = service.images.find {|image| image.name =~ /Ubuntu/}

#create server
server = service.servers.create :name => 'meta-cumulus',
                                :flavor_id => flavor.id,
                                :image_id => image.id,
                                :metadata => { 'color' => 'red'}

puts "Waiting for server to be created\n"
server.wait_for(600, 5) do
  print "."
  STDOUT.flush
  ready?
end

puts "[DONE]\n\n"

puts "Initial Metadata\n"
print_metadata(server)

puts "Adding New Metadata\n"
server.metadata["environment"] = "demo"
print_metadata(server)

puts "Updating Existing Metadata\n"
server.metadata["color"] = "blue"
print_metadata(server)

puts "Saving Metadata Changes\n"
server.metadata.save

puts "Reload Metadata\n"
server.metadata.reload
print_metadata(server)

puts "Delete Metadata"
metadatum = server.metadata.find {|metadataum| metadataum.key == 'environment'}
metadatum.destroy

puts "Reload Metadata"
server.metadata.reload
print_metadata(server)

puts "To delete the server please execute the delete_server.rb script\n\n"
