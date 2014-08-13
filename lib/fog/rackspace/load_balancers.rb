require 'fog/rackspace/core'

module Fog
  module Rackspace
    class LoadBalancers < Fog::Service
      include Fog::Rackspace::Errors

      #These references exist for backwards compatibility
      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end

      DFW_ENDPOINT = 'https://dfw.loadbalancers.api.rackspacecloud.com/v1.0'
      ORD_ENDPOINT = 'https://ord.loadbalancers.api.rackspacecloud.com/v1.0'
      LON_ENDPOINT = 'https://lon.loadbalancers.api.rackspacecloud.com/v1.0'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token
      recognizes :rackspace_lb_endpoint
      recognizes :rackspace_load_balancers_url
      recognizes :rackspace_region

      model_path 'fog/rackspace/models/load_balancers'
      collection :load_balancers
      model :load_balancer
      collection :nodes
      model :node
      collection :virtual_ips
      model :virtual_ip
      collection :access_rules
      model :access_rule

      request_path 'fog/rackspace/requests/load_balancers'
      request :get_ssl_termination
      request :set_ssl_termination
      request :remove_ssl_termination
      request :create_load_balancer
      request :get_load_balancer
      request :list_load_balancers
      request :update_load_balancer
      request :delete_load_balancer
      request :create_node
      request :list_nodes
      request :get_node
      request :update_node
      request :delete_node
      request :delete_nodes
      request :create_virtual_ip
      request :list_virtual_ips
      request :delete_virtual_ip
      request :list_protocols
      request :list_algorithms
      request :get_connection_logging
      request :set_connection_logging
      request :get_content_caching
      request :set_content_caching
      request :create_access_rule
      request :list_access_rules
      request :delete_access_rule
      request :delete_all_access_rules
      request :get_session_persistence
      request :set_session_persistence
      request :remove_session_persistence
      request :get_connection_throttling
      request :remove_connection_throttling
      request :set_connection_throttling
      request :get_monitor
      request :set_monitor
      request :remove_monitor
      request :get_usage
      request :get_load_balancer_usage
      request :get_error_page
      request :set_error_page
      request :remove_error_page
      request :get_stats

      module Shared
        def algorithms
          list_algorithms.body['algorithms'].map { |i| i['name'] }
        end

        def protocols
          list_protocols.body['protocols']
        end

        def usage(options = {})
          get_usage(options).body
        end
      end

      class Mock < Fog::Rackspace::Service
        include Shared

        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
        end
      end

      class Real < Fog::Rackspace::Service
        include Shared

        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_must_reauthenticate = false
          @connection_options     = options[:connection_options] || {}

          setup_custom_endpoint(options)

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
          :cloudLoadBalancers
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url, :rackspace_load_balancers_url)
        end

        private

        def setup_custom_endpoint(options)
          @rackspace_endpoint = Fog::Rackspace.normalize_url(options[:rackspace_load_balancers_url] || options[:rackspace_lb_endpoint])

          if v2_authentication?
            case @rackspace_endpoint
            when DFW_ENDPOINT
              @rackspace_endpoint = nil
              @rackspace_region = :dfw
            when ORD_ENDPOINT
              @rackspace_endpoint = nil
              @rackspace_region = :ord
            when LON_ENDPOINT
              @rackspace_endpoint = nil
              @rackspace_region = :lon
            else
              # we are actually using a custom endpoint
              @rackspace_region = options[:rackspace_region]
            end
          else
            #if we are using auth1 and the endpoint is not set, default to DFW_ENDPOINT for historical reasons
             @rackspace_endpoint ||= DFW_ENDPOINT
          end
        end

        def deprecation_warnings(options)
          Fog::Logger.deprecation("The :rackspace_lb_endpoint option is deprecated. Please use :rackspace_load_balancers_url for custom endpoints") if options[:rackspace_lb_endpoint]

          if [DFW_ENDPOINT, ORD_ENDPOINT, LON_ENDPOINT].include?(@rackspace_endpoint) && v2_authentication?
            regions = @identity_service.service_catalog.display_service_regions(service_name)
            Fog::Logger.deprecation("Please specify region using :rackspace_region rather than :rackspace_endpoint. Valid regions for :rackspace_region are #{regions}.")
          end
        end

        def append_tenant_v1(credentials)
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]

          endpoint = @rackspace_endpoint || credentials['X-Server-Management-Url'] || DFW_ENDPOINT
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
