require 'fog/rackspace/core'

module Fog
  module Rackspace
    class AutoScale < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end

      class BadRequest <  Fog::Rackspace::Errors::BadRequest
        attr_reader :validation_errors

        def self.slurp(error, service=nil)
          if error && error.response
            status_code = error.response.status
            if error.response.body
              body = Fog::JSON.decode(error.response.body)
              message = "#{body['type']} - #{body['message']}"
              details = error.response.body['details']
            end
          end

          new_error = new(message)
          new_error.set_backtrace(error.backtrace)
          new_error.instance_variable_set(:@validation_errors, details)
          new_error.instance_variable_set(:@status_code, status_code)
          new_error.set_transaction_id(error, service)
          new_error
        end
      end

        requires :rackspace_username, :rackspace_api_key
        recognizes :rackspace_auth_url
        recognizes :rackspace_region
        recognizes :rackspace_auto_scale_url

        model_path 'fog/rackspace/models/auto_scale'
        model :group
        collection :groups
        model :group_config
        model :launch_config

        model :policy
        collection :policies

        model :webhook
        collection :webhooks

        request_path 'fog/rackspace/requests/auto_scale'
        request :list_groups
        request :create_group
        request :get_group
        request :delete_group
        request :get_group_state
        request :pause_group_state
        request :resume_group_state

        request :get_group_config
        request :update_group_config
        request :get_launch_config
        request :update_launch_config

        request :list_policies
        request :create_policy
        request :get_policy
        request :update_policy
        request :delete_policy
        request :execute_policy

        request :execute_anonymous_webhook

        request :get_webhook
        request :list_webhooks
        request :create_webhook
        request :update_webhook
        request :delete_webhook

        class Mock < Fog::Rackspace::Service
          def initialize(options)
            @rackspace_api_key = options[:rackspace_api_key]
          end

          def request(params)
            Fog::Mock.not_implemented
          end
        end

        class Real < Fog::Rackspace::Service
          def initialize(options = {})
            @options = options
            @options[:connection_options] ||= {}
            @options[:persistent] ||= false

            authenticate

            @connection = Fog::Core::Connection.new(endpoint_uri.to_s, @options[:persistent], @options[:connection_options])
          end

          def request(params, parse_json = true, &block)
            super(params, parse_json, &block)
          rescue Excon::Errors::NotFound => error
            raise NotFound.slurp(error, self)
          rescue Excon::Errors::BadRequest => error
            raise BadRequest.slurp(error, self)
          rescue Excon::Errors::InternalServerError => error
            raise InternalServerError.slurp(error, self)
          rescue Excon::Errors::HTTPStatusError => error
            raise ServiceError.slurp(error, self)
          end

          def endpoint_uri(service_endpoint_url=nil)
            @uri = super(@options[:rackspace_auto_scale_url], :rackspace_auto_scale_url)
          end

          def authenticate(options={})
            super(select_options([:rackspace_username, :rackspace_api_key, :rackspace_auth_url, :connection_options]))
          end

          def service_name
            :autoscale
          end

          def request_id_header
            "x-response-id"
          end

          def region
            @options[:rackspace_region]
          end
        end
    end
  end
end
