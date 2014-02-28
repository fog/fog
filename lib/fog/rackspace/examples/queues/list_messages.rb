#!/usr/bin/env ruby

# This example demonstrates listing messages in a queue with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

def get_user_boolean(prompt)
  str = get_user_input(prompt)
  return false unless str
  str.match(/y(es)?/i) ? true : false
end

def select_queue(queues)
  abort "\nThere are not any queues to post a message to in the Chicago region. Try running create_queue.rb\n\n" if queues.empty?

  puts "\nSelect Queue:\n\n"
  queues.each_with_index do |queue, i|
    puts "\t #{i}. #{queue.name}"
  end

  delete_str = get_user_input "\nEnter Queue Number"
  queues[delete_str.to_i]
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

# retrieve list of queues
queues = service.queues

# prompt for queue to delete
queue = select_queue(queues)

queue.messages.echo = get_user_boolean "Do you want to include your own messages? [y/N]"

queue.messages.include_claimed = get_user_boolean "Do you want to include claimed messages? [y/N]"

puts "\n\nThe following messages are in the '#{queue.name}' queue:\n\n"

queue.messages.each do |message|
  puts message.inspect
end
