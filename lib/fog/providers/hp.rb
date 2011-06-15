require 'fog/core'

module Fog
  module HP

    extend Fog::Provider

    #service(:cdn,     'cdn/rackspace')
    #service(:compute, 'compute/rackspace')
    service(:storage, 'storage/hp')

    def self.authenticate(options)
      scheme = options[:scheme] || "http://"
      hp_auth_url = options[:hp_auth_url] || "auth.api.rackspacecloud.com"
      connection = Fog::Connection.new(scheme + hp_auth_url)
      @hp_username = options[:hp_username]
      @hp_password  = options[:hp_password]
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @hp_password,
          'X-Auth-User' => @hp_username
        },
        :host     => hp_auth_url,
        :method   => 'GET',
        :path     => 'auth/v1.0'
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end

  end
end
