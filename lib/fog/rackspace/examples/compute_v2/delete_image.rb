#!/usr/bin/env ruby

# This example demonstrates deleting a server image with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

def select_image(snapshot_images)
  abort "\nThere are not any images to delete in the Chicago region. Try running create_image.rb\n\n" if snapshot_images.empty?

  puts "\nSelect Image To Delete:\n\n"
  snapshot_images.each_with_index do |image, i|
    puts "\t #{i}. #{image.name}"
  end

  delete_str = get_user_input "\nEnter Image Number"
  snapshot_images[delete_str.to_i]
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

# retrieve list of images
images = service.images

# select all of the snapshot type images. base images are not user deletable
snapshot_images = images.select do |image|
  image.metadata["image_type"] == "snapshot"
end

# prompt user for image to delete
image = select_image(snapshot_images)

# delete image
image.destroy

puts "\n#{image.name} has been destroyed\n\n"
