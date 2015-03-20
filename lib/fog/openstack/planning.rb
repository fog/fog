require 'fog/openstack/core'

module Fog
  module Openstack
    class Planning < Fog::Service
      SUPPORTED_VERSIONS = /v2/

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                 :openstack_service_type, :openstack_service_name, :openstack_tenant,
                 :openstack_api_key, :openstack_username,
                 :current_user, :current_tenant, :openstack_endpoint_type, :openstack_region

      ## MODELS
      #
      model_path 'fog/openstack/models/planning'
      model       :role
      collection  :roles
      model       :plan
      collection  :plans

      ## REQUESTS
      #
      request_path 'fog/openstack/requests/planning'

      # Role requests
      request :list_roles

      # Plan requests
      request :list_plans
      request :get_plan_templates
      request :get_plan
      request :patch_plan
      request :create_plan
      request :delete_plan
      request :add_role_to_plan
      request :remove_role_from_plan

      class Mock
        def self.data
          @data ||= Hash.new
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openstack_username = options[:openstack_username]
          @openstack_tenant   = options[:openstack_tenant]
          @openstack_auth_uri = URI.parse(options[:openstack_auth_url])

          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          management_url = URI.parse(options[:openstack_auth_url])
          management_url.port = 9292
          management_url.path = '/v1'
          @openstack_management_url = management_url.to_s

          @data ||= { :users => {} }
          unless @data[:users].find {|u| u['name'] == options[:openstack_username]}
            id = Fog::Mock.random_numbers(6).to_s
            @data[:users][id] = {
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
            :openstack_region         => @openstack_region,
            :openstack_management_url => @openstack_management_url }
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

          @openstack_tenant               = options[:openstack_tenant]
          @openstack_auth_uri             = URI.parse(options[:openstack_auth_url])
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_service_type         = options[:openstack_service_type] || ['management'] # currently Tuskar is configured as 'management' service in Keystone
          @openstack_service_name         = options[:openstack_service_name]
          @openstack_endpoint_type        = options[:openstack_endpoint_type] || 'adminURL'
          @openstack_region               = options[:openstack_region]

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
              :path     => "#{@path}/#{params[:path]}"#,
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if !@openstack_management_url || @openstack_must_reauthenticate
            options = {
              :openstack_tenant   => @openstack_tenant,
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_region   => @openstack_region,
              :openstack_auth_token => @openstack_must_reauthenticate ? nil : @openstack_auth_token,
              :openstack_service_type => @openstack_service_type,
              :openstack_service_name => @openstack_service_name,
              :openstack_endpoint_type => @openstack_endpoint_type
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

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
          unless @path.match(SUPPORTED_VERSIONS)
            @path = "/v2"
          end
          @port   = uri.port
          @scheme = uri.scheme
          true
        end
      end
    end

    def self.[](service)
      new(:service => service)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      service = attributes.delete(:service).to_s.downcase.to_sym
      if services.include?(service)
        require "fog/openstack/#{service}"
        return Fog::Openstack.const_get(service.to_s.capitalize).new(attributes)
      end
      raise ArgumentError, "Openstack has no #{service} service"
    end

    def self.services
      # Ruby 1.8.7 compatibility for select returning Array of Arrays (pairs)
      Hash[Fog.services.select{|service, providers| providers.include?(:openstack)}].keys
    end
  end
end

