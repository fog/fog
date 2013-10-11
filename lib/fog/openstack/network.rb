require 'fog/openstack'

module Fog
  module Network
    class OpenStack < Fog::Service
      SUPPORTED_VERSIONS = /v2(\.0)*/

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                 :openstack_service_type, :openstack_service_name, :openstack_tenant,
                 :openstack_api_key, :openstack_username, :openstack_endpoint_type,
                 :current_user, :current_tenant, :openstack_region

      ## MODELS
      #
      model_path 'fog/openstack/models/network'
      model       :network
      collection  :networks
      model       :port
      collection  :ports
      model       :subnet
      collection  :subnets
      model       :floating_ip
      collection  :floating_ips
      model       :router
      collection  :routers
      model       :lb_pool
      collection  :lb_pools
      model       :lb_member
      collection  :lb_members
      model       :lb_health_monitor
      collection  :lb_health_monitors
      model       :lb_vip
      collection  :lb_vips

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

      # FloatingIp CRUD
      request :list_floating_ips
      request :create_floating_ip
      request :delete_floating_ip
      request :get_floating_ip
      request :associate_floating_ip
      request :disassociate_floating_ip

      # Router CRUD
      request :list_routers
      request :create_router
      request :delete_router
      request :get_router
      request :update_router
      request :add_router_interface
      request :remove_router_interface

      # LBaaS Pool CRUD
      request :list_lb_pools
      request :create_lb_pool
      request :delete_lb_pool
      request :get_lb_pool
      request :get_lb_pool_stats
      request :update_lb_pool

      # LBaaS Member CRUD
      request :list_lb_members
      request :create_lb_member
      request :delete_lb_member
      request :get_lb_member
      request :update_lb_member

      # LBaaS Health Monitor CRUD
      request :list_lb_health_monitors
      request :create_lb_health_monitor
      request :delete_lb_health_monitor
      request :get_lb_health_monitor
      request :update_lb_health_monitor
      request :associate_lb_health_monitor
      request :disassociate_lb_health_monitor

      # LBaaS VIP CRUD
      request :list_lb_vips
      request :create_lb_vip
      request :delete_lb_vip
      request :get_lb_vip
      request :update_lb_vip

      # Tenant
      request :set_tenant

      # Quota
      request :get_quotas
      request :get_quota
      request :update_quota
      request :delete_quota

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :networks => {},
              :ports => {},
              :subnets => {},
              :floating_ips => {},
              :routers => {},
              :lb_pools => {},
              :lb_members => {},
              :lb_health_monitors => {},
              :lb_vips => {},
              :quota => {
                "subnet" => 10,
                "router" => 10,
                "port" => 50,
                "network" => 10,
                "floatingip" => 50
              },
              :quotas => [
                {
                  "subnet" => 10,
                  "network" => 10,
                  "floatingip" => 50,
                  "tenant_id" => Fog::Mock.random_hex(8),
                  "router" => 10,
                  "port" => 30
                }
              ],
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
          @openstack_service_type         = options[:openstack_service_type] || ['network']
          @openstack_service_name         = options[:openstack_service_name]
          @openstack_endpoint_type        = options[:openstack_endpoint_type] || 'publicURL'
          @openstack_region               = options[:openstack_region]

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
            :current_tenant           => @current_tenant,
            :openstack_region         => @openstack_region }
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
              :path     => "#{@path}/#{params[:path]}"#,
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
              :openstack_service_type => @openstack_service_type,
              :openstack_service_name => @openstack_service_name,
              :openstack_endpoint_type => @openstack_endpoint_type,
              :openstack_region => @openstack_region
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
          unless @path.match(SUPPORTED_VERSIONS)
            @path = "/" + Fog::OpenStack.get_supported_version(SUPPORTED_VERSIONS,
                                                               uri,
                                                               @auth_token,
                                                               @connection_options)
          end
          @port   = uri.port
          @scheme = uri.scheme
          true
        end

      end
    end
  end
end
