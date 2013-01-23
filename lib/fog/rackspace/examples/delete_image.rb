#!/usr/bin/env ruby

# This example demonstrates deleting a server image with the Rackpace Open Cloud

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

#retrieve list of images
images = service.images

# select all of the snapshot type images. base images are not user deletable 
snapshot_images = images.select do |image|
  image.metadata["image_type"] == "snapshot" 
end

abort "\nThere are not any images avaliable to delete. Try running create_image.rb\n\n" if snapshot_images.empty?

puts "\nSelect image to delete:\n\n"
snapshot_images.each_with_index do |image, i|
  puts "\t #{i}. #{image.name}"
end

delete_str = get_user_input "\nEnter number (type 'ALL' to delete all images)"
abort "Unrecognized input. Exiting without deleting images." unless delete_str =~ /^ALL|\d+$/

confirm = get_user_input "Are you sure? (Y/N)"
abort "Exiting without deleting images" unless confirm == 'Y'

puts "\n\n"

if delete_str == 'ALL'
  snapshot_images.each {|image| image.destroy }
  puts "All images have been destroyed"
else
  image = snapshot_images[delete_str.to_i]
  image.destroy
  puts "#{image.name} has been destroyed"
end

