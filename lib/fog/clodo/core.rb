require 'fog/core'
require 'fog/json'

module Fog
  module Clodo
    extend Fog::Provider

    service(:compute, 'Compute')

    def self.authenticate(options)
      clodo_auth_url = options[:clodo_auth_url] || "api.clodo.ru"
      url = clodo_auth_url.match(/^https?:/) ? \
                clodo_auth_url : 'https://' + clodo_auth_url
      uri = URI.parse(url)
      connection = Fog::XML::Connection.new(url)
      @clodo_api_key  = options[:clodo_api_key]
      @clodo_username = options[:clodo_username]
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @clodo_api_key,
          'X-Auth-User' => @clodo_username
        },
        :host     => uri.host,
        :method   => 'GET',
        :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end # authenticate
  end # module Clodo
end # module Fog
