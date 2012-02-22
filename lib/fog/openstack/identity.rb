require File.expand_path(File.join(File.dirname(__FILE__), '..', 'openstack'))
require 'fog/openstack'

module Fog
  module Identity
    class OpenStack < Fog::Service

      requires :openstack_api_key, :openstack_username, :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                 :openstack_compute_service_name, :openstack_tenant

      model_path 'fog/openstack/models/identity'
      model       :tenant
      collection  :tenants
      model       :user
      collection  :users
      model       :role
      collection  :roles

      request_path 'fog/openstack/requests/identity'

      request :check_token
      request :validate_token

      request :list_tenants
      request :get_tenant
      request :get_tenants_by_id
      request :get_tenants_by_name

      request :list_users
      request :get_user_by_id
      request :get_user_by_name

      request :list_endpoints_for_token
      request :list_roles_for_user_on_tenant
      request :list_user_global_roles

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :users => {},
              :tenants => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'multi_json'
          @openstack_username = options[:openstack_username]
        end

        def data
          self.class.data[@openstack_username]
        end

        def reset_data
          self.class.data.delete(@openstack_username)
        end
      end

      class Real

        def initialize(options={})
          require 'multi_json'

          @openstack_api_key  = options[:openstack_api_key]
          @openstack_username = options[:openstack_username]
          @openstack_tenant   = options[:openstack_tenant]
          @openstack_auth_uri   = URI.parse(options[:openstack_auth_url])
          @openstack_auth_token = options[:openstack_auth_token]
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_compute_service_name = options[:openstack_compute_service_name] || ['identity']

          @connection_options = options[:connection_options] || {}

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}"#,
              # Causes errors for some requests like tenants?limit=1
              # :query    => ('ignore_awful_caching' << Time.now.to_i.to_s)
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @openstack_must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::OpenStack::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if @openstack_must_reauthenticate || @openstack_auth_token.nil?
            options = {
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_tenant   => @openstack_tenant,
              :openstack_compute_service_name => @openstack_compute_service_name,
              :openstack_endpoint_type => 'adminURL'
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end

          @host   = uri.host
          @path   = uri.path
          @path.sub!(/\/$/, '')
          @port   = uri.port
          @scheme = uri.scheme
          true
        end

      end
    end
  end
end
