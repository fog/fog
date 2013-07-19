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

      ENDPOINT = 'https://monitoring.api.rackspacecloud.com/v1.0'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent, :raise_errors
      recognizes :rackspace_auth_token, :rackspace_service_url, :rackspace_account_id

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

      request      :get_agent_token
      request      :get_alarm
      request      :get_alarm_example
      request      :get_check
      request      :get_entity

      request      :create_agent_token
      request      :create_alarm
      request      :create_check
      request      :create_entity

      request      :update_check
      request      :update_entity
      request      :update_alarm

      request      :delete_check
      request      :delete_entity

      request      :evaluate_alarm_example


      class Mock < Fog::Rackspace::Service
        def request(params)
          Fog::Mock.not_implemented
        end
      end

      class Real < Fog::Rackspace::Service
        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_auth_token = options[:rackspace_auth_token]
          @rackspace_account_id = options[:rackspace_account_id]
          @rackspace_service_url = options[:rackspace_service_url] || ENDPOINT
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}

          if options.has_key?(:raise_errors)
            @raise_errors = options[:raise_errors]
          else
            @raise_errors = true
          end

          begin
            authenticate
          rescue Exception => error
            raise_error(error)
          end

          @persistent = options[:persistent] || false

          begin
            @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          rescue Exception => error
            raise_error(error)
          end
        end

        def reload
          @connection.reset
        end

        def raise_error(error)
          if @raise_errors
            raise error
          else
            print "Error occurred: " + error.message
          end
        end

        def request(params)
          begin
            begin
              response = @connection.request(params.merge({
                :headers  => {
                  'Content-Type' => 'application/json',
                  'X-Auth-Token' => @auth_token
                }.merge!(params[:headers] || {}),
                :host     => @host,
                :path     => "#{@path}/#{params[:path]}"
              }))
            rescue Excon::Errors::Unauthorized => error
              if error.response.body != 'Bad username or password' # token expiration
                @rackspace_must_reauthenticate = true
                authenticate
                retry
              else # bad credentials
                raise error
              end
            rescue Excon::Errors::HTTPStatusError => error
              raise case error
              when Excon::Errors::NotFound
                Fog::Rackspace::Monitoring::NotFound.slurp error
              else
                error
              end
            end
            rescue Excon::Errors::BadRequest => error
              raise BadRequest.slurp error
            rescue Excon::Errors::NotFound
              raise NotFound.slurp error
            unless response.body.empty?
              response.body = JSON.decode(response.body)
            end
            response
          rescue Exception => error
            raise_error(error)
          end
        end

        private

        def authenticate
          if @rackspace_must_reauthenticate || @rackspace_auth_token.nil? || @account_id.nil?
            options = {
              :rackspace_api_key  => @rackspace_api_key,
              :rackspace_username => @rackspace_username,
              :rackspace_auth_url => @rackspace_auth_url
            }

            begin
              credentials = Fog::Rackspace.authenticate(options)
            rescue Exception => error
              raise_error(error)
              return
            end

            @auth_token = credentials['X-Auth-Token']
            @account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]
          else
            @auth_token = @rackspace_auth_token
            @account_id = @rackspace_account_id
          end
          uri = URI.parse("#{@rackspace_service_url}/#{@account_id}")
          @host   = uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
        end

      end
    end
  end
end
