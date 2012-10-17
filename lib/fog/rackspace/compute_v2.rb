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

      model_path 'fog/rackspace/models/compute_v2'
      model :server
      collection :servers
      model :flavor
      collection :flavors
      model :image
      collection :images
      model :attachments
      collection :attachments

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

      request :list_images
      request :get_image

      request :list_flavors
      request :get_flavor

      request :attach_volume
      request :get_attachment
      request :list_attachments
      request :delete_attachment

      class Mock
        def request(params)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def initialize(options = {})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}

          endpoint = options[:rackspace_endpoint] || DFW_ENDPOINT
          uri = URI.parse(endpoint)

          @host = uri.host
          @persistent = options[:persistent] || false
          @path = uri.path
          @port = uri.port
          @scheme = uri.scheme

          authenticate

          @connection = Fog::Connection.new(uri.to_s, @persistent, @connection_options)
        end

        def request(params)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}"
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          options = {
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url
          }
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]
          @path = "#{@path}/#{account_id}"
        end
      end
    end
  end
end
