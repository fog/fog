require 'fog/rackspace/core'

module Fog
  module Rackspace
    class CDNV2 < Fog::Service
      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent, :rackspace_cdn_ssl, :rackspace_region, :rackspace_cdn_url

      model_path 'fog/rackspace/models/cdn_v2'
      model :service
      collection :services

      model :flavor
      collection :flavors

      request_path 'fog/rackspace/requests/cdn_v2'
      request :create_service
      request :delete_assets
      request :delete_service
      request :get_flavor
      request :get_home_document
      request :get_ping
      request :get_service
      request :list_flavors
      request :list_services
      request :update_service

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end

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
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}

          authenticate

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

        def request_uri(path, options={})
          return path if options == {}
          require "addressable/uri"
          Addressable::URI.new({:path=>path, :query_values=>options}).request_uri
        end

        def ping
          self.get_ping.status == 204
        end

        def home_document
          self.get_home_document.body
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
          :rackCDN
        end

        def request_id_header
          "x-raxcdn-id"
        end

        def region
          @rackspace_region
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url)
        end
      end
    end
  end
end
