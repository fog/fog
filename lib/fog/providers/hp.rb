require 'fog/core'

module Fog
  module HP

    extend Fog::Provider

    #service(:cdn,     'cdn/rackspace')
    service(:compute, 'compute/hp')
    service(:storage, 'storage/hp')

    def self.authenticate(options)
      scheme = options[:scheme] || "http://"
      #hp_auth_url = options[:hp_auth_url] || "auth.api.rackspacecloud.com"
      @hp_host = options[:hp_host] || "auth.api.rackspacecloud.com"
      @hp_port = options[:hp_port] || "80"
      @hp_auth_path = options[:hp_auth_path] || "auth/v1.0"
      hp_auth_url = "#{@hp_host}:#{@hp_port}"
      connection = Fog::Connection.new(scheme + hp_auth_url)
      @hp_username = options[:hp_username]
      @hp_password  = options[:hp_password]
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @hp_password,
          'X-Auth-User' => @hp_username
        },
        :host     => @hp_host,
        :port     => @hp_port,
        :method   => 'GET',
        :path     => @hp_auth_path
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end

  end
end
