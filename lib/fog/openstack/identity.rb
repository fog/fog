require 'fog/openstack'

module Fog
  module Identity
    class OpenStack < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                 :openstack_service_name, :openstack_tenant,
                 :openstack_api_key, :openstack_username, :openstack_current_user_id,
                 :current_user, :current_tenant

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
      request :create_tenant
      request :get_tenant
      request :get_tenants_by_id
      request :get_tenants_by_name
      request :update_tenant
      request :delete_tenant

      request :list_users
      request :create_user
      request :update_user
      request :delete_user
      request :get_user_by_id
      request :get_user_by_name
      request :add_user_to_tenant
      request :remove_user_from_tenant

      request :list_endpoints_for_token
      request :list_roles_for_user_on_tenant
      request :list_user_global_roles

      request :create_role
      request :delete_role
      request :delete_user_role
      request :create_user_role
      request :get_role
      request :list_roles


      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :users => {},
              :roles => {},
              :tenants => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openstack_username = options[:openstack_username]

          unless self.data[:users].values.detect {|user| user['name'] == @openstack_username}
            id = Fog::Mock.random_numbers(6).to_s
            self.data[:users][id] = {
              'id'       => id,
              'name'     => options[:openstack_username],
              'email'    => "#{options[:openstack_username]}@mock.com",
              'tenantId' => Fog::Mock.random_numbers(6).to_s,
              'enabled'  => true
            }
          end
        end

        def data
          self.class.data[@openstack_username]
        end

        def reset_data
          self.class.data.delete(@openstack_username)
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
            :openstack_current_user_id => @openstack_current_user_id}
        end
      end

      class Real
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          @openstack_auth_token = options[:openstack_auth_token]

          unless @openstack_auth_token
            missing_credentials = Array.new
            @openstack_api_key  = options[:openstack_api_key]
            @openstack_username = options[:openstack_username]

            missing_credentials << :openstack_api_key  unless @openstack_api_key
            missing_credentials << :openstack_username unless @openstack_username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @openstack_tenant   = options[:openstack_tenant]
          @openstack_auth_uri   = URI.parse(options[:openstack_auth_url])
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_service_name = options[:openstack_service_name] || ['identity']

          @connection_options = options[:connection_options] || {}

          @openstack_current_user_id = options[:openstack_current_user_id]

          @current_user = options[:current_user]
          @current_tenant = options[:current_tenant]

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
            :openstack_current_user_id => @openstack_current_user_id,
            :current_user             => @current_user,
            :current_tenant           => @current_tenant }
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
              Fog::Identity::OpenStack::NotFound.slurp(error)
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
              :openstack_auth_token => @openstack_auth_token,
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_tenant   => @openstack_tenant,
              :openstack_service_name => @openstack_service_name,
              :openstack_endpoint_type => 'adminURL'
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            @openstack_current_user_id = credentials[:current_user_id]
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
