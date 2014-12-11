#!/usr/bin/env ruby

# This example demonstrates creating a server with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require "base64" #required to encode files for personality functionality

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

# pick the first flavor
flavor = service.flavors.first

# pick the first Ubuntu image we can find
image = service.images.find {|image| image.name =~ /Ubuntu/}

# prompt for server name
server_name = get_user_input "\nEnter Server Name"

# create server
server = service.servers.create :name => server_name,
                                :flavor_id => flavor.id,
                                :image_id => image.id,
                                :metadata => { 'fog_sample' => 'true'},
                                :personality => [{
                                  :path => '/root/fog.txt',
                                  :contents => Base64.encode64('Fog was here!')
                                }]

# reload flavor in order to retrieve all of its attributes
flavor.reload

puts "\nNow creating server '#{server.name}' the following with specifications:\n"
puts "\t* #{flavor.ram} MB RAM"
puts "\t* #{flavor.disk} GB"
puts "\t* #{flavor.vcpus} CPU(s)"
puts "\t* #{image.name}"

puts "\n"

begin
  # Check every 5 seconds to see if server is in the active state (ready?).
  # If the server has not been built in 5 minutes (600 seconds) an exception will be raised.
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
puts "To delete the server please execute the delete_server.rb script\n\n"
