## This is primarily used for easier testing and development or
#  usage of Fog.
#
#  How to use:
#  1. Add this at the end of your `.irbrc` in your home directory.
#
#    @working_directory = Dir.pwd
#    @local_irbrc = File.join(@working_directory, '.irbrc')
#
#    if @working_directory != ENV['HOME']
#      load @local_irbrc if File.exists?(@local_irbrc)
#    end
#
#    remove_instance_variable(:@working_directory)
#    remove_instance_variable(:@local_irbrc)
#
#  2. Inside the Fog execute `bundle exec irb`
#

require 'fog'

class ConnectionManager < Hash
  def [](key)
    $connection_manager_previous_key = key
    super(key)
  end

  def []=(key, value)
    $connection_manager_previous_key = key
    super(key, value)
  end
end

def connections
  return @connections if @connections
  @connections = ConnectionManager.new
end

def connection
  connections[$connection_manager_previous_key]
end

def connect_openstack(username, password, tenant = nil, url = 'http://192.168.27.100:35357/')
  parameters = {
    :provider => 'openstack',
    :openstack_api_key => password,
    :openstack_username => username,
    :openstack_auth_url => "#{url}v2.0/tokens"
  }

  parameters.merge!(:openstack_tenant => tenant) if tenant

  key = username.to_sym
  set_service(key, Fog::Identity, parameters)
  set_service(key, Fog::Compute, parameters)
  set_service(key, Fog::Volume, parameters)
  set_service(key, Fog::Image, parameters)
end

def connect(parameters)
  connections_count = connections.count
  connections[connections_count] = Hash.new

  set_service(connections_count, Fog::Identity, parameters)
  set_service(connections_count, Fog::Compute , parameters)
  set_service(connections_count, Fog::Storage , parameters)
  set_service(connections_count, Fog::Volume  , parameters)
  set_service(connections_count, Fog::Image   , parameters)
  set_service(connections_count, Fog::DNS     , parameters)
  set_service(connections_count, Fog::CDN     , parameters)
  connection
end

def set_service(connections_count, type, parameters)
  service_symbol = type.to_s.split('::').last.downcase.to_sym

  connections[connections_count].merge!({
    service_symbol => type.new(parameters)
  })
rescue
  # Service not available
end
