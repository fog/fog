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

def connect(username, password, tenant = nil, url = 'http://192.168.27.100:35357/')
  parameters = {
    :provider => 'openstack',
    :openstack_api_key => password,
    :openstack_username => username,
    :openstack_auth_url => "#{url}v2.0/tokens"
  }

  parameters.merge!(:openstack_tenant => tenant) if tenant

  identity = Fog::Identity.new(parameters)
  compute = Fog::Compute.new(parameters)
  image = Fog::Image.new(parameters)

  connections[username.to_sym] = {
    :identity => identity,
    :compute  => compute ,
    :image    => image
  }
end
