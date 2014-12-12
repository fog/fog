require 'fog/rackspace/core'

module Fog
  module Rackspace
    class Orchestration < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end

      ORCHESTRATION_DFW_URL = "https://dfw.orchestration.api.rackspacecloud.com/v1"
      ORCHESTRATION_LON_URL = "https://lon.orchestration.api.rackspacecloud.com/v1"
      ORCHESTRATION_IAD_URL = "https://iad.orchestration.api.rackspacecloud.com/v1"
      ORCHESTRATION_ORD_URL = "https://ord.orchestration.api.rackspacecloud.com/v1"

      requires :rackspace_username, :rackspace_api_key
      recognizes :rackspace_endpoint
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token
      recognizes :rackspace_region
      recognizes :rackspace_orchestration_url

      model_path 'fog/rackspace/models/orchestration'

      model :stack
      collection :stacks

      model :resource
      collection :resources

      collection :resource_schemas

      model :event
      collection :events

      model :template
      collection :templates

      request_path 'fog/rackspace/requests/orchestration'

      request :abandon_stack
      request :build_info
      request :create_stack
      request :delete_stack
      request :get_stack_template
      request :list_resource_events
      request :list_resource_types
      request :list_resources
      request :list_stack_data
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

      ## Redundant / Redirect requests:
      # request :adopt_stack          => :create_stack
      # request :find_stack           => :show_stack_details
      # request :find_stack_events    => :list_stack_events
      # request :find_stack_resources => :list_resources

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
          :cloudOrchestration
        end

        def request_id_header
          "x-orchestration-request-id"
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url, :rackspace_orchestration_url)
        end

        def request_uri(path, options={})
          return path if options == {}
          require "addressable/uri"
          Addressable::URI.new({:path=>path, :query_values=>options}).request_uri
        end

        private

        def setup_custom_endpoint(options)
          @rackspace_endpoint = Fog::Rackspace.normalize_url(options[:rackspace_orchestration_url] || options[:rackspace_endpoint])

          if v2_authentication?
            case @rackspace_endpoint
              when ORCHESTRATION_DFW_URL
                @rackspace_endpoint = nil
                @rackspace_region = :dfw
              when ORCHESTRATION_ORD_URL
                @rackspace_endpoint = nil
                @rackspace_region = :ord
              when ORCHESTRATION_IAD_URL
                @rackspace_endpoint = nil
                @rackspace_region = :iad
              when ORCHESTRATION_LON_URL
                @rackspace_endpoint = nil
                @rackspace_region = :lon
              else
                # we are actually using a custom endpoint
                @rackspace_region = options[:rackspace_region]
            end
          else
            #if we are using auth1 and the endpoint is not set, default to DFW_URL for historical reasons
            @rackspace_endpoint ||= ORCHESTRATION_DFW_URL
          end
        end

        def deprecation_warnings(options)
          Fog::Logger.deprecation("The :rackspace_endpoint option is deprecated. Please use :rackspace_orchestration_url for custom endpoints") if options[:rackspace_endpoint]

          if [ORCHESTRATION_DFW_URL, ORCHESTRATION_ORD_URL, ORCHESTRATION_IAD_URL, ORCHESTRATION_LON_URL].include?(@rackspace_endpoint) && v2_authentication?
            regions = @identity_service.service_catalog.display_service_regions(service_name)
            Fog::Logger.deprecation("Please specify region using :rackspace_region rather than :rackspace_endpoint. Valid regions for :rackspace_region are #{regions}.")
          end
        end

        def append_tenant_v1(credentials)
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]

          endpoint = @rackspace_endpoint || credentials['X-Server-Management-Url'] || ORCHESTRATION_DFW_URL
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
