require 'fog/compute'

module Fog
  module Compute
    class RackspaceV2 < Fog::Service

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end

      DFW_ENDPOINT = 'https://dfw.servers.api.rackspacecloud.com/v2'
      ORD_ENDPOINT = 'https://ord.servers.api.rackspacecloud.com/v2'
      LON_ENDPOINT = 'https://lon.servers.api.rackspacecloud.com/v2'

      requires :rackspace_username, :rackspace_api_key
      recognizes :rackspace_endpoint
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token
      recognizes :rackspace_region
      recognizes :rackspace_compute_url

      model_path 'fog/rackspace/models/compute_v2'
      model :server
      collection :servers
      model :flavor
      collection :flavors
      model :image
      collection :images
      model :attachment
      collection :attachments
      model :network
      collection :networks

      request_path 'fog/rackspace/requests/compute_v2'
      request :list_servers
      request :get_server
      request :create_server
      request :update_server
      request :delete_server
      request :change_server_password
      request :reboot_server
      request :rebuild_server
      request :resize_server
      request :confirm_resize_server
      request :revert_resize_server
      request :list_addresses
      request :list_addresses_by_network

      request :create_image
      request :list_images
      request :get_image
      request :delete_image

      request :list_flavors
      request :get_flavor

      request :attach_volume
      request :get_attachment
      request :list_attachments
      request :delete_attachment

      request :list_metadata
      request :set_metadata
      request :update_metadata
      request :get_metadata_item
      request :set_metadata_item
      request :delete_metadata_item

      request :list_networks
      request :get_network
      request :create_network
      request :delete_network

      class Mock
        include Fog::Rackspace::Authentication
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
          if params.has_key?(:expects) && ![*params[:expects]].include?(response.status)
            raise(Excon::Errors.status_error(params, response))
          else response
          end
        end
      end

      class Real
        include Fog::Rackspace::Authentication
        
        def initialize(options = {})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_endpoint = options[:rackspace_compute_url] || options[:rackspace_endpoint]
          @rackspace_region = options[:rackspace_region] || :dfw
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}

          @uri = authenticate

          deprecation_warnings(options)
          
          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new(@uri, @persistent, @connection_options)
        end
        
        def deprecation_warnings(options)
          Fog::Logger.deprecation("The :rackspace_endpoint option is deprecated. Please use :rackspace_compute_url for custom endpoints") if options[:rackspace_endpoint]
          
          if [DFW_ENDPOINT, ORD_ENDPOINT, LON_ENDPOINT].include?(@rackspace_endpoint) && v2_authentication?
            regions = @identity_service.service_catalog.display_service_regions(:cloudServersOpenStack)
            Fog::Logger.deprecation("Please specify region using :rackspace_region rather than :rackspace_endpoint. Valid region for :rackspace_region are #{regions}.")
          end
        end

        def request(params)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @uri.host,
              :path     => "#{@uri.path}/#{params[:path]}"
            }))
          rescue Excon::Errors::NotFound => error
            raise NotFound.slurp error
          rescue Excon::Errors::BadRequest => error
            raise BadRequest.slurp error
          rescue Excon::Errors::InternalServerError => error
            raise InternalServerError.slurp error
          rescue Excon::Errors::HTTPStatusError => error
            raise ServiceError.slurp error
          end

          unless response.body.empty?
            begin
              response.body = Fog::JSON.decode(response.body)
            rescue MultiJson::DecodeError => e
              response.body = {}
            end
          end
          response
        end
        
        def endpoint_uri(service_endpoint_url=nil)
          return @uri if @uri
          
          url  = @rackspace_endpoint || service_endpoint_url          
          unless url
            if v1_authentication?
              raise "Service Endpoint must be specified via :rackspace_compute_url parameter"
            else
              url = @identity_service.service_catalog.get_endpoint(:cloudServersOpenStack, @rackspace_region)            
            end
          end          
          @uri = URI.parse url
        end
        

        private        

        def authenticate
          options = {
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url,
          }
          self.send authentication_method, options  
        end                

        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]
          
          endpoint = @rackspace_endpoint || DFW_ENDPOINT
          @uri = URI.parse(endpoint)
          @uri.path = "#{@uri.path}/#{account_id}"
          @uri
        end
      end
    end
  end
end
