require 'fog/rackspace/files'
require 'fog/rackspace/servers'

module Fog
  module Rackspace

    def self.authenticate(options)
      unless @rackspace_api_key = options[:rackspace_api_key]
        raise ArgumentError.new('rackspace_api_key is required to access rackspace')
      end
      unless @rackspace_username = options[:rackspace_username]
        raise ArgumentError.new('rackspace_username is required to access rackspace')
      end
      connection = Fog::Connection.new("https://auth.api.rackspacecloud.com")
      response = connection.request({
        :expects  => 204,
        :headers  => {
          'X-Auth-Key'  => @rackspace_api_key,
          'X-Auth-User' => @rackspace_username
        },
        :host     => 'auth.api.rackspacecloud.com',
        :method   => 'GET',
        :path     => 'v1.0'
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end

  end
end
