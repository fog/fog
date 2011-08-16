module Fog
  module Rackspace
    class LoadBalancers < Fog::Service

      class ServiceError < Fog::Errors::Error
        attr_reader :response_data

        def self.slurp(error)
          if error.response.body.empty?
            data = nil
            message = nil
          else
            data = MultiJson.decode(error.response.body)
            message = data['message']
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error
        end
      end

      class InternalServerError < ServiceError; end

      class BadRequest < ServiceError
        #TODO - Need to find a bette way to print out these validation errors when they are thrown
        attr_reader :validation_errors

        def self.slurp(error)
          new_error = super(error)
          unless new_error.response_data.nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['validationErrors'])
          end
          new_error
        end
      end

      DFW_ENDPOINT = 'https://dfw.loadbalancers.api.rackspacecloud.com/v1.0/'
      ORD_ENDPOINT = 'https://ord.loadbalancers.api.rackspacecloud.com/v1.0/'
      LON_ENDPOINT = 'https://lon.loadbalancers.api.rackspacecloud.com/v1.0/'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token

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

      module Shared

        def algorithms
          list_algorithms.body['algorithms'].collect { |i| i['name'] }
        end

        def protocols
          list_protocols.body['protocols']
        end

        def usage(options = {})
          get_usage(options).body
        end

      end

      class Mock
        include Shared

        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
        end

      end

      class Real
        include Shared

        def initialize(options={})
          require 'multi_json'
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_must_reauthenticate = false
          uri = URI.parse(options[:rackspace_lb_endpoint] || DFW_ENDPOINT)
          @host = uri.host
          @path = uri.path
          @port = uri.port
          @scheme = uri.scheme

          authenticate

          @connection = Fog::Connection.new(uri.to_s, options[:persistent])
        end

        def request(params)
          #TODO - Unify code with other rackspace services
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
            response.body = MultiJson.decode(response.body)
          end
          response
        end

        def authenticate
          options = {
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url
          }
          credentials = Fog::Rackspace.authenticate(options)
          @auth_token = credentials['X-Auth-Token']
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]
          @path = "#{@path}/#{account_id}"
        end

      end
    end
  end
end
