require 'rubygems'
require 'json'

module Fog
  module Rackspace

    def self.reload
      load 'fog/rackspace/files.rb'
      load 'fog/rackspace/servers.rb'
    end

    def self.authenticate(options)
      connection = Fog::Connection.new("https://auth.api.rackspacecloud.com")
      response = connection.request({
        :expects  => 204,
        :headers  => {
          'X-Auth-Key'  => options[:rackspace_api_key],
          'X-Auth-User' => options[:rackspace_username]
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
Fog::Rackspace.reload