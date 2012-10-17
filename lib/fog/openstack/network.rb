require 'fog/openstack'

module Fog
  module Network
    class OpenStack < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                 :openstack_service_name, :openstack_tenant,
                 :openstack_api_key, :openstack_username,
                 :current_user, :current_tenant

      ## MODELS
      #
      model_path 'fog/openstack/models/network'
      model       :network
      collection  :networks
      model       :port
      collection  :ports
      model       :subnet
      collection  :subnets

      ## REQUESTS
      #
      request_path 'fog/openstack/requests/network'

      # Network CRUD
      request :list_networks
      request :create_network
      request :delete_network
      request :get_network
      request :update_network

      # Port CRUD
      request :list_ports
      request :create_port
      request :delete_port
      request :get_port
      request :update_port

      # Subnet CRUD
      request :list_subnets
      request :create_subnet
      request :delete_subnet
      request :get_subnet
      request :update_subnet

      # Tenant
      request :set_tenant

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :networks => {},
              :ports => {},
              :subnets => {},
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openstack_username = options[:openstack_username]
          @openstack_tenant   = options[:openstack_tenant]
        end

        def data
          self.class.data["#{@openstack_username}-#{@openstack_tenant}"]
        end

        def reset_data
          self.class.data.delete("#{@openstack_username}-#{@openstack_tenant}")
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url }
        end
      end

      class Real
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          require 'multi_json'

          @openstack_auth_token = options[:openstack_auth_token]

          unless @openstack_auth_token
            missing_credentials = Array.new
            @openstack_api_key  = options[:openstack_api_key]
            @openstack_username = options[:openstack_username]

            missing_credentials << :openstack_api_key  unless @openstack_api_key
            missing_credentials << :openstack_username unless @openstack_username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @openstack_tenant               = options[:openstack_tenant]
          @openstack_auth_uri             = URI.parse(options[:openstack_auth_url])
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_service_name         = options[:openstack_service_name] || ['network']

          @connection_options = options[:connection_options] || {}

          @current_user = options[:current_user]
          @current_tenant = options[:current_tenant]

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
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
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}"#,
              # Causes errors for some requests like tenants?limit=1
              # :query    => ('ignore_awful_caching' << Time.now.to_i.to_s)
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @openstack_must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Network::OpenStack::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if @openstack_must_reauthenticate || @openstack_auth_token.nil?
            options = {
              :openstack_tenant   => @openstack_tenant,
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_auth_token => @openstack_auth_token,
              :openstack_service_name => @openstack_service_name,
              :openstack_endpoint_type => 'adminURL'
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end

          @host   = uri.host
          @path   = uri.path
          @path.sub!(/\/$/, '')
          unless @path.match(/^\/v(\d)+(\.)?(\d)*$/)
            @path = "/" + retrieve_current_version(uri)
          end
          @port   = uri.port
          @scheme = uri.scheme
          true
        end

        def retrieve_current_version(uri)
          response = Fog::Connection.new(
            "#{uri.scheme}://#{uri.host}:#{uri.port}", false, @connection_options).request({
              :expects => [200, 204],
              :headers => {'Content-Type' => 'application/json',
                           'Accept' => 'application/json',
                           'X-Auth-Token' => @auth_token},
              :host    => uri.host,
              :method  => 'GET'
          })

          body = Fog::JSON.decode(response.body)
          version = nil
          unless body['versions'].empty?
            current_version = body['versions'].detect { |x| x["status"] == "CURRENT" }
            version = current_version["id"]
          end
          raise Errors::NotFound.new('No API versions found') if version.nil?
          version
        end

      end
    end
  end
end