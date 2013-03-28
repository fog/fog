#!/usr/bin/env ruby

# This example demonstrates creating Cloud Block Storage volume with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "\n#{prompt}: "
  gets.chomp
end

def select_volume_type(volume_types)
  puts "\nSelect Volume Type:\n\n"
  volume_types.each_with_index do |volume_type, i|
    puts "\t #{i}. #{volume_type.name}"
  end

  selected_str = get_user_input "Enter Volume Type Number"
  volume_types[selected_str.to_i]
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

# retrieve list of volume types
volume_types = service.volume_types

#prompt user for volume type
volume_type = select_volume_type(volume_types)

# prompt for volume size
volume_size = get_user_input "Enter Size of Volume (100 GB Minimum)"

# prompt for name of volume
volume_name = get_user_input "Enter Name for Volume"

#create volume
volume = service.volumes.create(:size => volume_size, :display_name => volume_name, :volume_type => volume_type.name)

puts "\nVolume #{volume_name} is being created.\n\n"
puts "To delete the volume please execute the delete_volume.rb script\n\n"
