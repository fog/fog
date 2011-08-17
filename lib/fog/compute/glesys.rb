module Fog
  module Compute
    class Glesys < Fog::Service

      requires :glesys_username, :glesys_api_key

      API_URL = "https://api.glesys.com"

      model_path 'fog/compute/models/glesys'
      collection  :servers
      model       :server
      collection  :templates
      model       :template
      collection  :ips
      model       :ip

      request_path 'fog/compute/requests/glesys'
      request :create
      request :destroy
      request :list_servers
      request :server_details
      request :server_status
      request :start
      request :stop
      # Templates 
      request :template_list
      # IP operations
      request :ip_list_free
      request :ip_list_own
      request :ip_details
      request :ip_take
      request :ip_release
      request :ip_add
      request :ip_remove


      class Mock
        include Collections

        def request(method_name, options = {})
          Fog::Mock.not_implemented
        end

      end

      class Real
        include Collections

        def initialize(options)
          require 'multi_json'
          require 'base64'

          @api_url = options[:glesys_api_url] || Fog.credentials[:glesys_api_url] || API_URL
          @glesys_username = options[:glesys_username] || Fog.credentials[:glesys_api_key]
          @glesys_api_key = options[:glesys_api_key] || Fog.credentials[:glesys_api_key]
          @connection = Fog::Connection.new(@api_url)
        end

        def request(method_name, options = {}) 

          options.merge!( {:format => 'json'})
          
          begin
            parser = options.delete(:parser)
            data = @connection.request(
              :expects => 200,
              :method  => "POST",
              :body    => urlencode(options),
              :parser  => parser,
              :path    => method_name,
              :headers => {
                'Authorization' => "Basic #{encoded_api_auth}",
                'Content-Type'  => 'application/x-www-form-urlencoded'
              }
            )

            data.body = MultiJson.decode(data.body)

            unless data.body['response']['status']['code'] == '200'
              raise Fog::Compute::Glesys::Error, "#{data.body['response']['status']['text']}"
            end
            data
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::Glesys::NotFound.slurp(error)
            else
              error
            end 
          end 
        end 

        private

        def encoded_api_auth
          token = [@glesys_username, @glesys_api_key].join(':')
          Base64.encode64(token).delete("\r\n")
        end

        def urlencode(hash)
          hash.to_a.collect! { |k, v| "#{k}=#{v.to_s}" }.join("&")
        end

      end

    end
  end
end
