require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module HP
    extend Fog::Provider

    service(:cdn,     'hp/cdn',     'CDN')
    service(:compute, 'hp/compute', 'Compute')
    service(:storage, 'hp/storage', 'Storage')

    def self.authenticate(options, connection_options = {})
      hp_auth_uri = options[:hp_auth_uri] || "https://region-a.geo-1.objects.hpcloudsvc.com/auth/v1.0/"
      endpoint = URI.parse(hp_auth_uri)
      @scheme = endpoint.scheme || "http"
      @host = endpoint.host || "region-a.geo-1.objects.hpcloudsvc.com"
      @port = endpoint.port.to_s || "80"
      if (endpoint.path)
        @auth_path = endpoint.path.slice(1, endpoint.path.length)  # remove the leading slash
      else
        @auth_path = "auth/v1.0"
      end
      service_url = "#{@scheme}://#{@host}:#{@port}"
      connection = Fog::Connection.new(service_url, false, connection_options)
      @hp_account_id = options[:hp_account_id]
      @hp_secret_key  = options[:hp_secret_key]
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @hp_secret_key,
          'X-Auth-User' => @hp_account_id
        },
        :host     => @host,
        :port     => @port,
        :method   => 'GET',
        :path     => @auth_path
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end

    class Mock
      def self.etag
        Fog::Mock.random_hex(32)
      end

    end

  end
end
