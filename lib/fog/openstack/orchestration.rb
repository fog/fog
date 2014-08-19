require 'fog/openstack/core'

module Fog
  module Orchestration
    class OpenStack < Fog::Service
      requires :auth_url
      recognizes :auth_token, :management_url,
                 :persistent, :service_type, :service_name,
                 :tenant,
                 :api_key, :username, :identity_endpoint,
                 :current_user, :current_tenant, :region,
                 :endpoint_type

      model_path 'fog/openstack/models/orchestration'
      model       :stack
      collection  :stacks

      request_path 'fog/openstack/requests/orchestration'
      request :create_stack
      request :update_stack
      request :delete_stack
      request :list_stacks

      class Mock
        attr_reader :auth_token
        attr_reader :auth_token_expiration
        attr_reader :current_user
        attr_reader :current_tenant

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :stacks => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @username = options[:username]
          @auth_uri = URI.parse(options[:auth_url])

          @current_tenant = options[:tenant]

          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          management_url = URI.parse(options[:auth_url])
          management_url.port = 8774
          management_url.path = '/v1'
          @management_url = management_url.to_s

          identity_public_endpoint = URI.parse(options[:auth_url])
          identity_public_endpoint.port = 5000
          @identity_public_endpoint = identity_public_endpoint.to_s
        end

        def data
          self.class.data["#{@username}-#{@current_tenant}"]
        end

        def reset_data
          self.class.data.delete("#{@username}-#{@current_tenant}")
        end

        def credentials
          { :provider                 => 'openstack',
            :auth_url       => @auth_uri.to_s,
            :auth_token     => @auth_token,
            :management_url => @management_url,
            :identity_endpoint => @identity_public_endpoint }
        end
      end

      class Real
        attr_reader :auth_token
        attr_reader :auth_token_expiration
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          @auth_token = options[:auth_token]
          @auth_token        = options[:auth_token]
          @identity_public_endpoint = options[:identity_endpoint]

          unless @auth_token
            missing_credentials = Array.new
            @api_key  = options[:api_key]
            @username = options[:username]

            missing_credentials << :api_key  unless @api_key
            missing_credentials << :username unless @username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @tenant     = options[:tenant]
          @auth_uri   = URI.parse(options[:auth_url])
          @management_url       = options[:management_url]
          @must_reauthenticate  = false
          @service_type = options[:service_type] || ['orchestration']
          @service_name = options[:service_name]
          @identity_service_type = options[:identity_service_type] || 'identity'
          @endpoint_type = options[:endpoint_type] || 'publicURL'
          @region      = options[:region]

          @connection_options = options[:connection_options] || {}

          @current_user = options[:current_user]
          @current_tenant = options[:current_tenant]

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def credentials
          { :provider                 => 'openstack',
            :auth_url       => @auth_uri.to_s,
            :auth_token     => @auth_token,
            :management_url => @management_url,
            :identity_endpoint => @identity_public_endpoint,
            :region         => @region,
            :current_user             => @current_user,
            :current_tenant           => @current_tenant }
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token,
                'X-Auth-User'  => @username,
                'X-Auth-Key'   => @api_key
              }.merge!(params[:headers] || {}),
              :path     => "#{@path}/#{@tenant_id}/#{params[:path]}",
              :query    => params[:query]
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @must_reauthenticate = true
              authenticate
              retry
            else # Bad Credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
              when Excon::Errors::NotFound
                Fog::Compute::OpenStack::NotFound.slurp(error)
              else
                error
              end
          end

          if !response.body.empty? and response.get_header('Content-Type') =~ /application\/json/ then
            response.body = Fog::JSON.decode(response.body)
          end

          response
        end

        private

        def authenticate
          if !@management_url || @must_reauthenticate
            options = {
              :api_key    => @api_key,
              :username   => @username,
              :auth_token => @auth_token,
              :auth_uri   => @auth_uri,
              :region     => @region,
              :tenant     => @tenant,
              :service_type => @service_type,
              :service_name => @service_name,
              :identity_service_type => @identity_service_type,
              :endpoint_type => @endpoint_type
            }

            if @auth_uri.path =~ /\/v2.0\//

              credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)
            else
              credentials = Fog::OpenStack.authenticate_v1(options, @connection_options)
            end

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @must_reauthenticate = false
            @auth_token               = credentials[:token]
            @auth_token_expiration    = credentials[:expires]
            @management_url = credentials[:server_management_url]
            @identity_public_endpoint  = credentials[:identity_public_endpoint]
          end

          uri = URI.parse(@management_url)
          @host   = uri.host
          @path, @tenant_id = uri.path.scan(/(\/.*)\/(.*)/).flatten

          @path.sub!(/\/$/, '')

          @port   = uri.port
          @scheme = uri.scheme

          # Not all implementations have identity service in the catalog
          if @identity_public_endpoint || @management_url
            @identity_connection = Fog::Core::Connection.new(
              @identity_public_endpoint || @management_url,
              false, @connection_options)
          end

          true
        end
      end
    end
  end
end
