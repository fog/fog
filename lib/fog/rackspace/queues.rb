require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rackspace'))

module Fog
  module Rackspace
    class Queues < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end
      class MethodNotAllowed < Fog::Rackspace::Errors::BadRequest; end

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token
      recognizes :rackspace_region
      recognizes :rackspace_queues_url
      recognizes :rackspace_queues_client_id


      model_path 'fog/rackspace/models/queues'
      model :queue
      collection :queues
      model :message
      collection :messages
      model :claim
      collection :claims

      request_path 'fog/rackspace/requests/queues'
      request :list_queues
      request :get_queue
      request :create_queue
      request :delete_queue
      request :get_queue_stats

      request :list_messages
      request :get_message
      request :create_message
      request :delete_message
      request :create_claim
      request :get_claim
      request :update_claim
      request :delete_claim

      class Mock < Fog::Rackspace::Service
        def request(params)
          Fog::Mock.not_implemented
        end
      end

      class Real < Fog::Rackspace::Service

        def service_name
          :cloudQueues
        end

        def region
          @rackspace_region
        end

        def initialize(options = {})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_queues_client_id = options[:rackspace_queues_client_id] || Fog::UUID.uuid
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}
          @rackspace_region = options[:rackspace_region] || :ord

          unless v2_authentication?
            raise Fog::Errors::NotImplemented.new("V2 authentication required for Queues")
          end

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
        end

        def request(params, parse_json = true, &block)
          super(params, parse_json, &block)
        rescue Excon::Errors::NotFound => error
          raise NotFound.slurp(error, self)
        rescue Excon::Errors::BadRequest => error
          raise BadRequest.slurp(error, self)
        rescue Excon::Errors::InternalServerError => error
          raise InternalServerError.slurp(error, self)
        rescue Excon::Errors::MethodNotAllowed => error
          raise MethodNotAllowed.slurp(error, self)
        rescue Excon::Errors::HTTPStatusError => error
          raise ServiceError.slurp(error, self)
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url, :rackspace_queues_url)
        end

        def authenticate(options={})
          super({
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url,
            :connection_options => @connection_options
          })
        end

        def client_id
          @rackspace_queues_client_id
        end

        def client_id=(client_id)
          @rackspace_queues_client_id = client_id
        end
      end
    end
  end
end
