#!/usr/bin/env ruby

# This example demonstrates creating a file on the CDN network with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

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

# create Cloud Files service
service = Fog::Storage.new({
  :provider             => 'Rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
  })

# prompt for directory name
directory_name = get_user_input "\nEnter name of directory to create"

# create directory with CDN service
directory = service.directories.create :key => directory_name, :public => true

# upload file
upload_file = File.join(File.dirname(__FILE__), "lorem.txt")
file = directory.files.create :key => 'sample.txt', :body => File.open(upload_file, "r")

puts "You should be able to view this file via CDN at #{file.public_url}"
puts "To delete the container and associated file please execute the delete_directory.rb script\n\n"
