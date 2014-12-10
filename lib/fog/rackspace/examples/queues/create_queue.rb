#!/usr/bin/env ruby

# This example demonstrates creating a queue with the Rackpace Open Cloud

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

# create Queue Service
service = Fog::Rackspace::Queues.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord #Use Chicago Region
})

#prompt for queue name
queue_name = get_user_input "Enter name for queue"

begin
  # create queue
  queue = service.queues.create :name => queue_name
  puts "Queue #{queue_name} was successfully created"

  puts "To delete the queue please execute the delete_queue.rb script\n\n"
rescue Fog::Rackspace::Queues::ServiceError => e
  if e.status_code == 204
    puts "Queue #{queue_name} already exists"
  end
end
