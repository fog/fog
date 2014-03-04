#!/usr/bin/env ruby

# This example demonstrates deleting a file from a container with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

def select_directory(directories)
  abort "\nThere are not any directories with files to delete in the Chicago region. Try running create_file.rb\n\n" if directories.empty?

  puts "\nSelect Directory:\n\n"
  directories.each_with_index do |dir, i|
    puts "\t #{i}. #{dir.key} [#{dir.count} objects]"
  end

  delete_str = get_user_input "\nEnter Directory Number"
  directories[delete_str.to_i]
end

def select_file(files)
  puts "\nSelect File:\n\n"
  files.each_with_index do |file, i|
    puts "\t #{i}. #{file.key}"
  end

  delete_str = get_user_input "\nEnter File Number"
  files[delete_str.to_i]
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

# retrieve directories with files
directories = service.directories.select {|s| s.count > 0}

# prompt for directory
directory = select_directory(directories)

# list of files for directory
files = directory.files

# prompt for file to delete
file = select_file(files)

# delete file
file.destroy

puts "\nFile #{file.key} was successfully deleted"
