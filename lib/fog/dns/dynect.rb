module Fog
  module Dynect
    class DNS < Fog::Service

      requires :dynect_customer, :dynect_username, :dynect_password
      recognizes :timeout, :persistent
      recognizes :provider # remove post deprecation

      # model_path 'fog/dns/models/dynect'
      # model       :record
      # collection  :records
      # model       :zone
      # collection  :zones

      request_path 'fog/dns/requests/dynect'
      request :session

      class Real
        def initialize(options={})
          @dynect_customer = options[:dynect_customer]
          @dynect_username = options[:dynect_username]
          @dynect_password = options[:dynect_password]

          @host = "api2.dynect.net"
          @port   = options[:port]    || 443
          @scheme = options[:scheme]  || 'https'
          @version = options[:version]  || '2.3.1'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent] || true)
        end

        def request(params)
          begin
            params[:headers] ||= {}
            params[:headers]['Content-Type'] = 'text/xml'
            params[:headers]['API-Version'] = @version
            response = @connection.request(params.merge!({:host => @host}))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
                  when Excon::Errors::NotFound
                    Fog::Dynect::DNS::NotFound.slurp(error)
                  else
                    error
                  end
          end

          response
        end
      end

      class Mock
        def zones
        end
      end

    end
  end
end
