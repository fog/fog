require 'fog/openstack/core'

module Fog
  module Orchestration
    class OpenStack < Fog::Service
      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_service_type, :openstack_service_name,
                 :openstack_tenant,
                 :openstack_api_key, :openstack_username, :openstack_identity_endpoint,
                 :current_user, :current_tenant, :openstack_region,
                 :openstack_endpoint_type

      model_path 'fog/openstack/models/orchestration'
      model       :stack
      collection  :stacks

      model :resource
      collection :resources

      collection :resource_schemas

      model :event
      collection :events

      model :template
      collection :templates

      request_path 'fog/openstack/requests/orchestration'
      request :abandon_stack
      request :build_info
      request :create_stack
      request :delete_stack
      request :get_stack_template
      request :list_events
      request :list_resource_events
      request :list_resource_types
      request :list_resources
      request :list_stack_data
      request :list_stack_data_detailed
      request :list_stack_events
      request :preview_stack
      request :show_event_details
      request :show_resource_data
      request :show_resource_metadata
      request :show_resource_schema
      request :show_resource_template
      request :show_stack_details
      request :update_stack
      request :validate_template

      module Reflectable

        REFLECTION_REGEX = /\/stacks\/(\w+)\/([\w|-]+)\/resources\/(\w+)/

        def resource
          @resource ||= service.resources.get(r[3], stack)
        end

        def stack
          @stack ||= service.stacks.get(r[1], r[2])
        end

        private

        def reflection
          @reflection ||= REFLECTION_REGEX.match(self.links[0]['href'])
        end
        alias :r :reflection
      end

      class Mock
        attr_reader :auth_token
        attr_reader :auth_token_expiration
        attr_reader :current_user
        attr_reader :current_tenant

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :stacks => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openstack_username = options[:openstack_username]
          @openstack_auth_uri = URI.parse(options[:openstack_auth_url])

          @current_tenant = options[:openstack_tenant]

          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          management_url = URI.parse(options[:openstack_auth_url])
          management_url.port = 8774
          management_url.path = '/v1'
          @openstack_management_url = management_url.to_s

          identity_public_endpoint = URI.parse(options[:openstack_auth_url])
          identity_public_endpoint.port = 5000
          @openstack_identity_public_endpoint = identity_public_endpoint.to_s
        end

        def data
          self.class.data["#{@openstack_username}-#{@current_tenant}"]
        end

        def reset_data
          self.class.data.delete("#{@openstack_username}-#{@current_tenant}")
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
            :openstack_identity_endpoint => @openstack_identity_public_endpoint }
        end
      end

      class Real
        attr_reader :auth_token
        attr_reader :auth_token_expiration
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          @openstack_auth_token = options[:openstack_auth_token]
          @auth_token        = options[:openstack_auth_token]
          @openstack_identity_public_endpoint = options[:openstack_identity_endpoint]

          unless @auth_token
            missing_credentials = Array.new
            @openstack_api_key  = options[:openstack_api_key]
            @openstack_username = options[:openstack_username]

            missing_credentials << :openstack_api_key  unless @openstack_api_key
            missing_credentials << :openstack_username unless @openstack_username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @openstack_tenant     = options[:openstack_tenant]
          @openstack_auth_uri   = URI.parse(options[:openstack_auth_url])
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_service_type = options[:openstack_service_type] || ['orchestration']
          @openstack_service_name = options[:openstack_service_name]
          @openstack_identity_service_type = options[:openstack_identity_service_type] || 'identity'
          @openstack_endpoint_type = options[:openstack_endpoint_type] || 'publicURL'
          @openstack_region      = options[:openstack_region]

          @connection_options = options[:connection_options] || {}

          @current_user = options[:current_user]
          @current_tenant = options[:current_tenant]

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
            :openstack_identity_endpoint => @openstack_identity_public_endpoint,
            :openstack_region         => @openstack_region,
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
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token,
                'X-Auth-User'  => @openstack_username,
                'X-Auth-Key'   => @openstack_api_key
              }.merge!(params[:headers] || {}),
              :path     => "#{@path}/#{@tenant_id}/#{params[:path]}",
              :query    => params[:query]
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @openstack_must_reauthenticate = true
              authenticate
              retry
            else # Bad Credentials
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

          if !response.body.empty? and response.get_header('Content-Type') =~ /application\/json/ then
            response.body = Fog::JSON.decode(response.body)
          end

          response
        end

        private

        def authenticate
          if !@openstack_management_url || @openstack_must_reauthenticate
            options = {
              :openstack_api_key    => @openstack_api_key,
              :openstack_username   => @openstack_username,
              :openstack_auth_token => @openstack_must_reauthenticate ? nil : @auth_token,
              :openstack_auth_uri   => @openstack_auth_uri,
              :openstack_region     => @openstack_region,
              :openstack_tenant     => @openstack_tenant,
              :openstack_service_type => @openstack_service_type,
              :openstack_service_name => @openstack_service_name,
              :openstack_identity_service_type => @openstack_identity_service_type,
              :openstack_endpoint_type => @openstack_endpoint_type
            }

            credentials = Fog::OpenStack.authenticate(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token               = credentials[:token]
            @auth_token_expiration    = credentials[:expires]
            @openstack_management_url = credentials[:server_management_url]
            @openstack_identity_public_endpoint  = credentials[:identity_public_endpoint]
          end

          uri = URI.parse(@openstack_management_url)
          @host   = uri.host
          @path, @tenant_id = uri.path.scan(/(\/.*)\/(.*)/).flatten

          @path.sub!(/\/$/, '')

          @port   = uri.port
          @scheme = uri.scheme

          # Not all implementations have identity service in the catalog
          if @openstack_identity_public_endpoint || @openstack_management_url
            @identity_connection = Fog::Core::Connection.new(
              @openstack_identity_public_endpoint || @openstack_management_url,
              false, @connection_options)
          end

          true
        end
      end
    end
  end
end
