#!/usr/bin/env ruby

# This example demonstrates creating an auto scaling group with the Rackpace Open Cloud

require 'fog'

# UUID for INTERNET
INTERNET = '00000000-0000-0000-0000-000000000000'

# UUID for Rackspace's service net
SERVICE_NET = '11111111-1111-1111-1111-111111111111'

def get_user_input(prompt)
  print "#{prompt}: "
  gets.chomp
end

def get_user_input_as_int(prompt)
  str = get_user_input(prompt)
  str.to_i
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


def select_image(images)
  puts "\nSelect Image For Server:\n\n"
  images.each_with_index do |image, i|
    puts "\t #{i}. #{image.name}"
  end

  select_str = get_user_input "\nEnter Image Number"
  images[select_str.to_i]
end


# create auto scaling service
auto_scale_service = Fog::Rackspace::AutoScale.new({
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :rackspace_region => :ord # Use Chicago Region
})


# create Next Generation Cloud Server service to get list of flavors
compute_service = Fog::Compute.new({
  :provider             => 'rackspace',
  :rackspace_username   => rackspace_username,
  :rackspace_api_key    => rackspace_api_key,
  :version => :v2,  # Use Next Gen Cloud Servers
  :rackspace_region => :ord # Use Chicago Region
})


# prompt for scaling group name
scaling_group_name = get_user_input "Enter name of scaling group"

# prompt for cool down period
cool_down = get_user_input_as_int "Enter cool down period in seconds"

# prompt for miniumum number of entities
min_entities = get_user_input_as_int "Enter minimum number of servers"

# prompt for max number of entities
max_entities = get_user_input_as_int "Enter maximum number of servers"

# prompt for base name server name
server_name = get_user_input "Enter base name for servers in scaling group '#{scaling_group_name}'"

# retrieve list of images from computer service
print "Loading available server images...."
images = compute_service.images.all
puts "[DONE]"

# prompt for server image
image = select_image(images)

# pick first server flavor
flavor = compute_service.flavors.first

server_template =   {
  "name" => "autoscale_server",
  "imageRef" => image.id,
  "flavorRef" => flavor.id,
  "OS-DCF =>diskConfig" => "MANUAL",
  "metadata" => {
    "build_config" => "core",
    "meta_key_1" => "meta_value_1",
    "meta_key_2" => "meta_value_2"
  },
  "networks" => [
    {
      "uuid" => "11111111-1111-1111-1111-111111111111"
    },
    {
      "uuid" => "00000000-0000-0000-0000-000000000000"
    }
  ],
  "personality" => [
    {
      "path" => "/root/.csivh",
      "contents" => "VGhpcyBpcyBhIHRlc3QgZmlsZS4="
    }
  ]
  }

# create launch configuration
launch_config = Fog::Rackspace::AutoScale::LaunchConfig.new :type => :launch_server, :args => {:server => server_template }

# create group configuration
group_config = Fog::Rackspace::AutoScale::GroupConfig.new :max_entities => max_entities,
  :min_entities => min_entities,
  :cooldown => cool_down,
  :name => scaling_group_name,
  :metadata => { "created_by" => "autoscale sample script" }

# create scaling group
group = auto_scale_service.groups.create :group_config => group_config,
  :launch_config => launch_config

puts "\nScaling Group #{scaling_group_name} (#{group.id}) was created!"
puts "State: #{group.state}"
