#!/usr/bin/env ruby

# This example demonstrates deleting Cloud Block Storage volume with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
 print "\n#{prompt}: "
 gets.chomp
end

def select_volume(volumes)
  abort "\nThere are not any volumes to delete in the Chicago region. Try running create_volume.rb\n\n" if volumes.empty?

  puts "\nSelect Volume:\n\n"
  volumes.each_with_index do |volume, i|
    puts "\t #{i}. #{volume.display_name}"
  end

 selected_str = get_user_input "Enter Volume Type Number"
 volumes[selected_str.to_i]
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

# create Cloud Block Storage service
service = Fog::Rackspace::BlockStorage.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
})

# retrieve list of volumes
volumes = service.volumes

# prompt user for volume
volume = select_volume(volumes)

# delete volume
volume.destroy

puts "\nVolume #{volume.display_name} is being destroyed.\n\n"
