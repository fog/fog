require 'fog/rackspace/core'

module Fog
  module Rackspace
    class Identity < Fog::Service
      US_ENDPOINT = 'https://identity.api.rackspacecloud.com/v2.0'
      UK_ENDPOINT = 'https://lon.identity.api.rackspacecloud.com/v2.0'

      requires :rackspace_username, :rackspace_api_key
      recognizes :rackspace_auth_url, :rackspace_region

      model_path 'fog/rackspace/models/identity'
      model :user
      collection :users
      model :role
      collection :roles
      model :credential
      collection :credentials
      model :tenant
      collection :tenants
      model :service_catalog

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

      module Common
        attr_reader :service_catalog, :auth_token

        def authenticate(options={})
          data = self.create_token(@rackspace_username, @rackspace_api_key).body
          @service_catalog = ServiceCatalog.from_response(self, data)
          @auth_token = data['access']['token']['id']
        end

        def apply_options(options)
          @rackspace_username = options[:rackspace_username]
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_region = options[:rackspace_region]
          @rackspace_auth_url = options[:rackspace_auth_url] || US_ENDPOINT

          @uri = URI.parse(@rackspace_auth_url)
          @host = @uri.host
          @path = @uri.path
          @port = @uri.port
          @scheme = @uri.scheme
          @persistent = options[:persistent] || false
          @connection_options = options[:connection_options] || {}
        end
      end

      class Mock < Fog::Rackspace::Service
        include Common

        def initialize(options={})
          apply_options(options)

          authenticate
        end
      end

      class Real < Fog::Rackspace::Service
        include Common

        def initialize(options={})
          apply_options(options)
          @connection = Fog::Core::Connection.new(@uri.to_s, @persistent, @connection_options)

          authenticate
        end
      end
    end
  end
end
