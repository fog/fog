module Fog
  module DNS
    class Rackspace < Fog::Service

      US_ENDPOINT = 'https://dns.api.rackspacecloud.com/v1.0'
      UK_ENDPOINT = 'https://lon.dns.api.rackspacecloud.com/v1.0'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token

      model_path 'fog/dns/models/rackspace'
      #TODO - Need to add
      #model       :record
      #collection  :records
      #model       :zone
      #collection  :zones

      request_path 'fog/dns/requests/rackspace'
      request :list_domains

      class Mock
      end

      class Real
        def initialize(options={})
          require 'multi_json'
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          uri = URI.parse(options[:rackspace_dns_endpoint] || US_ENDPOINT)

          @auth_token, @account_id = *authenticate
          @path = "#{uri.path}/#{@account_id}"
          headers = { 'Content-Type' => 'application/json', 'X-Auth-Token' => @auth_token }

          @connection = Fog::Connection.new(uri.to_s, options[:persistent], { :headers => headers})
        end

        private

        def request(params)
          #TODO - Unify code with other rackspace services
          begin
            response = @connection.request(params.merge!({
              :path     => "#{@path}/#{params[:path]}"
            }))
          #TODO - Going to add rescues for the different expected errors
          end
          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end

        def authenticate
          options = {
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url
          }
          credentials = Fog::Rackspace.authenticate(options)
          auth_token = credentials['X-Auth-Token']
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]
          [auth_token, account_id]
        end
      end
    end
  end
end
