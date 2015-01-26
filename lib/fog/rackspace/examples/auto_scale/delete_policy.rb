#!/usr/bin/env ruby

# This example demonstrates deleting an auto scaling policy with the Rackpace Open Cloud

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

def select_group(groups)
  abort "\nThere are no groups in the Chicago region. Try running create_scaling_group.rb\n\n" if groups.empty?

  puts "\nSelect Group With Policy:\n\n"
  groups.each_with_index do |group, i|
    config = group.group_config
    puts "\t #{i}. #{config.name}"
  end

  select_str = get_user_input "\nEnter Group Number"
  groups[select_str.to_i]
end

def select_policy(policies)
  abort "\nThere are no policies for this scaling group. Try running add_policy.rb\n\n" if policies.empty?

  puts "\nSelect Policy To Delete:\n\n"
  policies.each_with_index do |policies, i|
    puts "\t #{i}. #{policies.name}"
  end

  select_str = get_user_input "\nEnter Policy Number"
  policies[select_str.to_i]
end

# create auto scaling service
auto_scale_service = Fog::Rackspace::AutoScale.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord # Use Chicago Region
})

# retrieve list of scaling groups
groups = auto_scale_service.groups

# prompt for group
group = select_group(groups)

# retrieve list of policies for group
policies = group.policies

# prompt for policy to delete
policy = select_policy(policies)

# delete policy
policy.destroy

puts "\nPolicy '#{policy.name}' has been destroyed\n\n"
