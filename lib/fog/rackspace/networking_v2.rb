require 'fog/rackspace/core'

module Fog
  module Rackspace
    class NetworkingV2 < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end

      NETWORKS_DFW_URL = "https://dfw.networks.api.rackspacecloud.com/v2.0"
      NETWORKS_LON_URL = "https://lon.networks.api.rackspacecloud.com/v2.0"
      NETWORKS_IAD_URL = "https://iad.networks.api.rackspacecloud.com/v2.0"
      NETWORKS_ORD_URL = "https://ord.networks.api.rackspacecloud.com/v2.0"

      class InvalidStateException < ::RuntimeError
        attr_reader :desired_state
        attr_reader :current_state

        def initialize(desired_state, current_state)
          @desired_state = desired_state
          @current_state = current_state
        end
      end

      class InvalidServerStateException < InvalidStateException
        def to_s
          "Server should have transitioned to '#{desired_state}' not '#{current_state}'"
        end
      end

      class InvalidImageStateException < InvalidStateException
        def to_s
          "Image should have transitioned to '#{desired_state}' not '#{current_state}'"
        end
      end

      requires :rackspace_username, :rackspace_api_key
      recognizes :rackspace_endpoint
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token
      recognizes :rackspace_region
      recognizes :rackspace_networking_v2_url

      model_path 'fog/rackspace/models/networking_v2'

      model :network
      collection :networks

      model :subnet
      collection :subnets

      model :port
      collection :ports

      model :security_group
      collection :security_groups

      model :security_group_rule
      collection :security_group_rules

      request_path 'fog/rackspace/requests/networking_v2'
      request :list_networks
      request :create_network
      request :show_network
      request :update_network
      request :delete_network

      request :list_subnets
      request :create_subnet
      request :show_subnet
      request :update_subnet
      request :delete_subnet

      request :list_ports
      request :create_port
      request :show_port
      request :update_port
      request :delete_port

      request :list_security_groups
      request :create_security_group
      request :show_security_group
      request :update_security_group
      request :delete_security_group

      request :list_security_group_rules
      request :create_security_group_rule
      request :show_security_group_rule
      request :delete_security_group_rule

      class Mock < Fog::Rackspace::Service
        include Fog::Rackspace::MockData

        def initialize(options)
          @rackspace_api_key = options[:rackspace_api_key]
        end

        def request(params)
          Fog::Mock.not_implemented
        end

        def response(params={})
          body    = params[:body] || {}
          status  = params[:status] || 200
          headers = params[:headers] || {}

          response = Excon::Response.new(:body => body, :headers => headers, :status => status)
          if params.key?(:expects) && ![*params[:expects]].include?(response.status)
            raise(Excon::Errors.status_error(params, response))
          else response
          end
        end
      end

      class Real < Fog::Rackspace::Service
        def initialize(options = {})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          setup_custom_endpoint(options)
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}

          authenticate

          deprecation_warnings(options)

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
        end

        def request(params, parse_json = true)
          super
        rescue Excon::Errors::NotFound => error
          raise NotFound.slurp(error, self)
        rescue Excon::Errors::BadRequest => error
          raise BadRequest.slurp(error, self)
        rescue Excon::Errors::InternalServerError => error
          raise InternalServerError.slurp(error, self)
        rescue Excon::Errors::HTTPStatusError => error
          raise ServiceError.slurp(error, self)
        end

        def authenticate(options={})
          super({
                  :rackspace_api_key => @rackspace_api_key,
                  :rackspace_username => @rackspace_username,
                  :rackspace_auth_url => @rackspace_auth_url,
                  :connection_options => @connection_options
          })
        end

        def service_name
          :cloudNetworks
        end

        def request_id_header
          "x-networks-request-id"
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url, :rackspace_networking_v2_url)
        end

        private

        def setup_custom_endpoint(options)
          @rackspace_endpoint = Fog::Rackspace.normalize_url(options[:rackspace_networking_v2_url] || options[:rackspace_endpoint])

          if v2_authentication?
            case @rackspace_endpoint
            when NETWORKS_DFW_URL
              @rackspace_endpoint = nil
              @rackspace_region = :dfw
            when NETWORKS_ORD_URL
              @rackspace_endpoint = nil
              @rackspace_region = :ord
            when NETWORKS_LON_URL
              @rackspace_endpoint = nil
              @rackspace_region = :lon
            else
              # we are actually using a custom endpoint
              @rackspace_region = options[:rackspace_region]
            end
          else
            #if we are using auth1 and the endpoint is not set, default to NETWORKS_DFW_URL for historical reasons
            @rackspace_endpoint ||= NETWORKS_DFW_URL
          end
        end

        def deprecation_warnings(options)
          Fog::Logger.deprecation("The :rackspace_endpoint option is deprecated. Please use :rackspace_networking_v2_url for custom endpoints") if options[:rackspace_endpoint]

          if [NETWORKS_DFW_URL, NETWORKS_ORD_URL, NETWORKS_LON_URL].include?(@rackspace_endpoint) && v2_authentication?
            regions = @identity_service.service_catalog.display_service_regions(service_name)
            Fog::Logger.deprecation("Please specify region using :rackspace_region rather than :rackspace_endpoint. Valid regions for :rackspace_region are #{regions}.")
          end
        end

        def append_tenant_v1(credentials)
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]

          endpoint = @rackspace_endpoint || credentials['X-Server-Management-Url'] || NETWORKS_DFW_URL
          @uri = URI.parse(endpoint)
          @uri.path = "#{@uri.path}/#{account_id}"
        end

        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          append_tenant_v1 credentials
          @auth_token = credentials['X-Auth-Token']
        end
      end
    end
  end
end
