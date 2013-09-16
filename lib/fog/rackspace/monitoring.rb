# This class originally came from the rackspace-monitoring gem located here:
# https://github.com/racker/rackspace-monitoring-rb
# It has been heavily modified for import into Fog master.

require 'fog'
require 'fog/core'

module Fog
  module Rackspace
    class Monitoring < Fog::Service
      include Fog::Rackspace::Errors

      class IdentifierTaken < Fog::Errors::Error; end
      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end
      class Conflict < Fog::Rackspace::Errors::Conflict; end
      class ServiceUnavailable < Fog::Rackspace::Errors::ServiceUnavailable; end

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :persistent
      recognizes :rackspace_monitoring_url
      recognizes :rackspace_region

      model_path  'fog/rackspace/models/monitoring'
      model       :entity
      collection  :entities
      model       :check
      collection  :checks
      model       :alarm
      collection  :alarms
      model       :alarm_example
      collection  :alarm_examples
      model       :agent_token
      collection  :agent_tokens
      model       :metric
      collection  :metrics
      model       :data_point
      collection  :data_points
      model       :check_type
      collection  :check_types
      model       :notification
      collection  :notifications

      request_path 'fog/rackspace/requests/monitoring'
      request      :list_agent_tokens
      request      :list_alarms
      request      :list_alarm_examples
      request      :list_checks
      request      :list_entities
      request      :list_metrics
      request      :list_data_points
      request      :list_check_types
      request      :list_overview
      request      :list_notification_plans
      request      :list_notifications

      request      :get_agent_token
      request      :get_alarm
      request      :get_alarm_example
      request      :get_check
      request      :get_entity
      request      :get_notification

      request      :create_agent_token
      request      :create_alarm
      request      :create_check
      request      :create_entity
      request      :create_notification

      request      :update_check
      request      :update_entity
      request      :update_alarm
      request      :update_notification

      request      :delete_agent_token
      request      :delete_alarm
      request      :delete_check
      request      :delete_entity
      request      :delete_notification

      request      :evaluate_alarm_example


      class Mock < Fog::Rackspace::Service

        def initialize(options={})
        end

        def request(params)
          Fog::Mock.not_implemented
        end
      end

      class Real < Fog::Rackspace::Service
        def service_name
          :cloudMonitoring
        end

        def region
          @rackspace_region
        end

        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @connection_options = options[:connection_options] || {}
          @rackspace_endpoint = Fog::Rackspace.normalize_url(options[:rackspace_monitoring_url])

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url, :rackspace_monitoring_url)
        end

        def request_id_header
         "X-Response-Id"
        end

        private

        def request(params, parse_json = true, &block)
          super(params, parse_json, &block)
          rescue Excon::Errors::BadRequest => error
            raise BadRequest.slurp(error, self)
          rescue Excon::Errors::Conflict => error
            raise Conflict.slurp(error, self)
          rescue Excon::Errors::NotFound => error
            raise NotFound.slurp(error, self)
          rescue Excon::Errors::ServiceUnavailable => error
            raise ServiceUnavailable.slurp(error, self)
          rescue Excon::Errors::InternalServerError => error
            raise InternalServerError.slurp(error, self)
          rescue Excon::Errors::HTTPStatusError => error
            raise ServiceError.slurp(error, self)
        end

        def authenticate
          options = {
            :rackspace_api_key => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url,
            :connection_options => @connection_options
          }
          super(options)
        end
      end
    end
  end
end
