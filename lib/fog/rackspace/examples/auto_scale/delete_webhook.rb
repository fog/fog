#!/usr/bin/env ruby

# This example demonstrates delete a webhook from an auto scaling group with the Rackpace Open Cloud

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

  puts "\nSelect Policy With Webhook:\n\n"
  policies.each_with_index do |policy, i|
    puts "\t #{i}. #{policy.name}"
  end

  select_str = get_user_input "\nEnter Policy Number"
  policies[select_str.to_i]
end

def select_webhook(webhooks)
  abort "\nThere are no webhooks for this policy. Try running add_webhook.rb\n\n" if webhooks.empty?

  puts "\nSelect Webhook:\n\n"
  webhooks.each_with_index do |webhook, i|
    puts "\t #{i}. #{webhook.name}"
  end

  select_str = get_user_input "\nEnter Webhook Number"
  webhooks[select_str.to_i]
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

# prompt for policy
policy = select_policy(policies)

# retrieve list of webhooks for policy
webhooks = policy.webhooks

# prompt for webhook
webhook = select_webhook(webhooks)

# delete webhook
webhook.destroy

puts "Webhook '#{webhook.name} was destroyed"
