require 'fog/core'

module Fog
  module Rackspace

    extend Fog::Provider

    service(:cdn,     'cdn/rackspace')
    service(:compute, 'compute/rackspace')
    service(:storage, 'storage/rackspace')
    service(:load_balancers, 'rackspace/load_balancers')

    def self.authenticate(options)
      rackspace_auth_url = options[:rackspace_auth_url] || "auth.api.rackspacecloud.com"
      url = rackspace_auth_url.match(/^https?:/) ? \
                rackspace_auth_url : 'https://' + rackspace_auth_url
      uri = URI.parse(url)
      connection = Fog::Connection.new(url)
      @rackspace_api_key  = options[:rackspace_api_key]
      @rackspace_username = options[:rackspace_username]
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @rackspace_api_key,
          'X-Auth-User' => @rackspace_username
        },
        :host     => uri.host,
        :method   => 'GET',
        :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end

  end
end
