module Fog
  module Dynect
    class DNS < Fog::Service

      requires :dynect_customer, :dynect_username, :dynect_password
      recognizes :timeout, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/dns/models/dynect'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/dns/requests/dynect'
      request :session
      request :list_zones
      request :get_zone
      request :list_any_records
      request :node_list

      class Real
        def initialize(options={})
          require 'builder'

          @dynect_customer = options[:dynect_customer]
          @dynect_username = options[:dynect_username]
          @dynect_password = options[:dynect_password]

          @host    = "api2.dynect.net"
          @port    = options[:port]    || 443
          @path    = options[:path]    || '/REST'
          @scheme  = options[:scheme]  || 'https'
          @version = options[:version] || '2.3.1'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent] || true)
        end

        def auth_token
          @auth_token ||= session.body['Auth-Token']
        end

        def request(params)
          begin
            params[:headers] ||= {}
            params[:headers]['Content-Type'] = 'text/xml'
            params[:headers]['API-Version'] = @version
            params[:headers]['Auth-Token'] = auth_token unless params[:path] == "Session"
            params[:path] = "#{@path}/#{params[:path]}"
            response = @connection.request(params.merge!({:host => @host}))
            response = handle_redirect(response) if response.status == 307
          rescue Excon::Errors::HTTPStatusError => error
            raise error
          end

          response
        end
      end

      def handle_redirect(response)
          raise request({
                    :expects  => 200,
                    :method   => "GET",
                    :path     => response.body
                  })


      end

      # class Mock
      # end

    end
  end
end
