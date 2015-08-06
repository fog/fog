require 'fog/openstack/core'

module Fog
  module Openstack
    class Planning < Fog::Service
      SUPPORTED_VERSIONS = /v2/

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_service_type, :openstack_service_name,
                 :openstack_tenant, :openstack_tenant_id,
                 :openstack_api_key, :openstack_username, :openstack_identity_endpoint,
                 :current_user, :current_tenant, :openstack_region,
                 :openstack_endpoint_type,
                 :openstack_project_name, :openstack_project_id,
                 :openstack_project_domain, :openstack_user_domain, :openstack_domain_name,
                 :openstack_project_domain_id, :openstack_user_domain_id, :openstack_domain_id

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
        include Fog::OpenStack::Core

        def initialize(options={})
          initialize_identity options

          @openstack_service_type           = options[:openstack_service_type] || ['management'] # currently Tuskar is configured as 'management' service in Keystone
          @openstack_service_name           = options[:openstack_service_name]
          @openstack_endpoint_type          = options[:openstack_endpoint_type] || 'adminURL'

          @connection_options               = options[:connection_options] || {}

          authenticate

          unless @path.match(SUPPORTED_VERSIONS)
            @path = "/v2"
          end

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
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
