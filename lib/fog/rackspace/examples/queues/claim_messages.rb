#!/usr/bin/env ruby

# This example demonstrates claiming messages with the Rackpace Open Cloud

require 'rubygems' #required for Ruby 1.8.x
require 'fog'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

def select_queue(queues)
  abort "\nThere are not any queues the Chicago region. Try running create_queue.rb\n\n" if queues.empty?

  puts "\nSelect Queue To Delete:\n\n"
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

# prompt for queue
queue = select_queue(queues)

# prompt for number of messages to claim
num_claims = get_user_input "Enter Number of Messages to Claim"

# Claim messages
claim = queue.claims.create :ttl => 300, :grace => 100, :limit => num_claims

puts "The following messages have been claimed for the next 5 minutes [#{claim.id}]"

claim.messages.each do |message|
  puts "\t[#{message.id}] #{message.body[0..50]}"
end
