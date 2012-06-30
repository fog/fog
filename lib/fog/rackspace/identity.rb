require 'fog/rackspace'

module Fog
  module Rackspace
    class Identity < Fog::Service
      US_ENDPOINT = 'https://identity.api.rackspacecloud.com/v2.0'
      UK_ENDPOINT = 'https://lon.identity.api.rackspacecloud.com/v2.0'

      requires :rackspace_username, :rackspace_api_key
      recognizes :rackspace_auth_url

      model_path 'fog/rackspace/models/identity'
      model :user
      collection :users
      model :role
      collection :roles
      model :credential
      collection :credentials
      model :tenant
      collection :tenants

      request_path 'fog/rackspace/requests/identity'
      request :create_token

      request :list_users
      request :list_user_roles
      request :list_credentials
      request :list_tenants
      request :get_user_by_id
      request :get_user_by_name
      request :create_user
      request :update_user
      request :delete_user
      request :get_credentials

      class Mock
        def request
          Fog::Mock.not_implemented
        end
      end

      class Real
        def initialize(options={})
          @rackspace_username = options[:rackspace_username]
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_auth_url = options[:rackspace_auth_url] || US_ENDPOINT

          uri = URI.parse(@rackspace_auth_url)
          @host = uri.host
          @path = uri.path
          @port = uri.port
          @scheme = uri.scheme
          @persistent = options[:persistent] || false
          @connection_options = options[:connection_options] || {}
          @connection = Fog::Connection.new(uri.to_s, @persistent, @connection_options)

          authenticate
        end

        def request(params)
          begin
            parameters = params.merge!({
              :headers => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              },
              :host => @host,
              :path => "#{@path}/#{params[:path]}"
            })
            response = @connection.request(parameters)
            response.body = Fog::JSON.decode(response.body) unless response.body.empty?
            response
          end
        end

        def authenticate
          data = self.create_token(@rackspace_username, @rackspace_api_key).body
          @auth_token = data['access']['token']['id']
        end
      end
    end
  end
end
