#!/usr/bin/env ruby

# This example demonstrates creating a server with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'
require 'base64' #required to encode files for personality functionality
require 'sshkey' #required to generate ssh keys. 'gem install sshkey'

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

# Generates a ssh key using the SSHKey library. The private key is avaialble via
# the '.private_key' and the public key is avaialble via '.ssh_public_key'
def generate_ssh_key
  SSHKey.generate
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

# generate the ssh key
ssh_key = generate_ssh_key

# reload flavor in order to retrieve all of its attributes
flavor.reload

puts "\nNow creating server '#{server_name}' the following with specifications:\n"
puts "\t* #{flavor.ram} MB RAM"
puts "\t* #{flavor.disk} GB"
puts "\t* #{flavor.vcpus} CPU(s)"
puts "\t* #{image.name}"
puts "\n"

begin
  # bootstrap server
  server = service.servers.bootstrap :name => server_name,
                                     :flavor_id => flavor.id,
                                     :image_id => image.id,
                                     :private_key => ssh_key.private_key,
                                     :public_key => ssh_key.ssh_public_key

  if server.ready?
    puts "[DONE]\n\n"

    puts "The server has been successfully created.\n"
    puts "Write the following ssh keys to you ~/.ssh directory in order to log in\n\n"
    puts "+++++++++++PRIVATE_KEY (~/.ssh/fog_key)++++++++++++"
    puts ssh_key.private_key
    puts "++++++++++PUBLIC_KEY (~/.ssh/fog_key.pub)++++++++++"
    puts ssh_key.ssh_public_key
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++i\n\n"

    puts "You can then log into the server using the following command\n"
    puts "ssh #{server.username}@#{server.public_ip_address}\n\n"
  else
    puts "An error occured, please try again"
  end

rescue Fog::Errors::TimeoutError
  puts "[TIMEOUT]\n\n"

  puts "This server is currently #{server.progress}% into the build process and is taking longer to complete than expected."
  puts "You can continute to monitor the build process through the web console at https://mycloud.rackspace.com/\n\n"
end

puts "To delete the server please execute the delete_server.rb script\n\n"
