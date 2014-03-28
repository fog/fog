module Fog
  module Orchestration
    class Rackspace < Fog::Service

      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end


      class Real < Fog::Rackspace::Service; end
      class Mock < Fog::Rackspace::Service; end

      requires :rackspace_username, :rackspace_api_key
      recognizes :rackspace_endpoint
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token
      recognizes :rackspace_region
      recognizes :rackspace_compute_url

      model_path 'fog/rackspace/models/orchestration'
      model :stack
      collection :stacks

      request_path 'fog/rackspace/requests/orchestration'
      request :create_stack
      request :update_stack
      request :delete_stack
      request :list_stacks
      request :list_resources_stack
      request :data_stack
      request :list_events_stack
      request :template_stack

      DFW_ENDPOINT = 'https://dfw.orchestration.api.rackspacecloud.com/v1'
      ORD_ENDPOINT = 'https://ord.orchestration.api.rackspacecloud.com/v1'
      LON_ENDPOINT = 'https://lon.orchestration.api.rackspacecloud.com/v1'


      class Real
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
          @connection = Fog::XML::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
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
          "x-orchestrate-request-id"
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url, :rackspace_compute_url)
        end

        private

        def setup_custom_endpoint(options)
          @rackspace_endpoint = Fog::Rackspace.normalize_url(options[:rackspace_compute_url] || options[:rackspace_endpoint])

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
              @rackspace_region = options[:rackspace_region] || :dfw
            end
          else
            #if we are using auth1 and the endpoint is not set, default to DFW_ENDPOINT for historical reasons
            @rackspace_endpoint ||= DFW_ENDPOINT
          end
        end

        def deprecation_warnings(options)
          Fog::Logger.deprecation("The :rackspace_endpoint option is deprecated. Please use :rackspace_compute_url for custom endpoints") if options[:rackspace_endpoint]

          if [DFW_ENDPOINT, ORD_ENDPOINT, LON_ENDPOINT].include?(@rackspace_endpoint) && v2_authentication?
            regions = @identity_service.service_catalog.display_service_regions(service_name)
            Fog::Logger.deprecation("Please specify region using :rackspace_region rather than :rackspace_endpoint. Valid regions for :rackspace_region are #{regions}.")
          end

          unless options[:rackspace_region]
            Fog::Logger.deprecation("Default region support will be removed in an upcoming release. Please switch to manually setting your endpoint. This requires settng the :rackspace_region option")
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
