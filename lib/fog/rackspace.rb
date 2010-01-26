module Fog
  module Rackspace

    def self.reload
      load 'fog/rackspace/files.rb'
      load 'fog/rackspace/servers.rb'
    end

    unless Fog.mocking?

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

    else

      def self.authenticate(options)
        {
          'X-Auth_Token'            => '01234567-0123-0123-0123-01234',
          'X-CDN-Management-Url'    => 'https://cdn.cloaddrive.com/v1/CloudFS_01234-0123',
          'X-Server-Management-Url' => 'https://servers.api.rackspacecloud.com/v1.0/01234',
          'X-Storage-Url'           => 'https://storage.clouddrive.com/v1/CloudFS_01234-0123'
        }
      end

      srand(Time.now.to_i)

      class Mock
      end

    end

  end
end
Fog::Rackspace.reload
