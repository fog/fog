module Fog
  module DNS
    class Dynect < Fog::Service

      requires :dynect_customer, :dynect_username, :dynect_password
      recognizes :timeout, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/dns/models/dynect'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/dns/requests/dynect'
      request :delete_record
      request :delete_zone
      request :get_node_list
      request :get_record
      request :get_zone
      request :post_record
      request :post_session
      request :post_zone
      request :put_zone

      class Mock

        def initialize(options={})
          @dynect_customer = options[:dynect_customer]
          @dynect_username = options[:dynect_username]
          @dynect_password = options[:dynect_password]
        end

      end

      class Real
        def initialize(options={})
          require 'multi_json'

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
          @auth_token ||= post_session.body['data']['token']
        end

        def request(params)
          begin
            params[:headers] ||= {}
            params[:headers]['Content-Type'] = 'application/json'
            params[:headers]['API-Version'] = @version
            params[:headers]['Auth-Token'] = auth_token unless params[:path] == "Session"
            params[:path] = "#{@path}/#{params[:path]}"
            response = @connection.request(params.merge!({:host => @host}))

            unless response.body.empty?
              response.body = MultiJson.decode(response.body)
            end
            response

          rescue Excon::Errors::HTTPStatusError => error
            raise error
          end

          response
        end
      end

    end
  end
end
