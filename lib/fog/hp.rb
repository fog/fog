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

      def self.key_fingerprint
        fingerprint = []
        20.times do
          fingerprint << Fog::Mock.random_hex(2)
        end
        fingerprint.join(':')
      end

      def self.key_material
        private_key = OpenSSL::PKey::RSA.generate(1024)
        public_key = private_key.public_key
        return private_key.to_s, public_key.to_s
      end

      def self.user_id
        "dev_" + Fog::Mock.random_numbers(14)
      end

      def self.instance_id
        Fog::Mock.random_numbers(6)
      end

      def self.ip_address
        ip = []
        4.times do
          ip << Fog::Mock.random_numbers(rand(3) + 1).to_i.to_s # remove leading 0
        end
        ip.join('.')
      end

    end

  end
end
