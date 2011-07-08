module Fog
  module Rackspace
    class LoadBalancer < Fog::Service

      DFW_ENDPOINT = 'https://dfw.loadbalancers.api.rackspacecloud.com/v1.0/'
      ORD_ENDPOINT = 'https://ord.loadbalancers.api.rackspacecloud.com/v1.0/'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token

      model_path 'fog/rackspace/models'

      request_path 'fog/rackspace/requests'
      request :create_load_balancer
      request :get_load_balancer
      request :list_load_balancers
      request :update_load_balancer
      request :delete_load_balancer

      class Real
        def initialize(options={})
          require 'json'
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
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::Rackspace::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = JSON.parse(response.body)
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

