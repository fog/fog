require 'fog/core'

module Fog
  module Rackspace

    extend Fog::Provider

    service(:cdn,     'cdn/rackspace')
    service(:compute, 'compute/rackspace')
    service(:storage, 'storage/rackspace')

    def self.authenticate(options)
      rackspace_auth_url = options[:rackspace_auth_url] || "auth.api.rackspacecloud.com"
      connection = Fog::Connection.new("https://" + rackspace_auth_url)
      @rackspace_api_key  = options[:rackspace_api_key]
      @rackspace_username = options[:rackspace_username]
      response = connection.request({
        :expects  => 204,
        :headers  => {
          'X-Auth-Key'  => @rackspace_api_key,
          'X-Auth-User' => @rackspace_username
        },
        :host     => rackspace_auth_url,
        :method   => 'GET',
        :path     => 'v1.0'
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end

  end
end
