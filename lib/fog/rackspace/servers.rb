module Fog
  module Rackspace
    class Servers

      def self.reload
        load "fog/rackspace/requests/servers/get_flavors.rb"
        load "fog/rackspace/requests/servers/get_images.rb"
        load "fog/rackspace/requests/servers/get_servers.rb"
      end

      def initialize(options={})
        credentials = Fog::Rackspace.authenticate(options)
        @auth_token = credentials['X-Auth-Token']
        uri = URI.parse(credentials['X-Server-Management-Url'])
        @host   = uri.host
        @path   = uri.path
        @port   = uri.port
        @scheme = uri.scheme
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
      end

      def request(params)
        response = @connection.request({
          :body     => params[:body],
          :expects  => params[:expects],
          :headers  => {
            'X-Auth-Token' => @auth_token
          },
          :host     => @host,
          :method   => params[:method],
          :path     => "#{@path}/#{params[:path]}"
        })
        response.body = JSON.parse(response.body)
        response
      end

    end
  end
end
Fog::Rackspace::Servers.reload