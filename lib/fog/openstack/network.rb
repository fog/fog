require 'fog/openstack/core'

module Fog
  module Network
    class OpenStack < Fog::Service
      SUPPORTED_VERSIONS = /v2(\.0)*/

      # the openstack_* params are all deprecated. remove the
      # 'openstack_' part of the string from your config parameter names.
      requires :openstack_auth_url
      recognizes :auth_url

      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                 :openstack_service_type, :openstack_service_name, :openstack_tenant,
                 :openstack_api_key, :openstack_username, :openstack_endpoint_type,
                 :current_user, :current_tenant, :openstack_region

      recognizes :auth_token, :management_url, :persistent,
                 :service_type, :service_name, :tenant,
                 :api_key, :username, :endpoint_type,
                 :current_user, :current_tenant, :region

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
      model       :security_group
      collection  :security_groups
      model       :security_group_rule
      collection  :security_group_rules

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

      # Security Group
      request :create_security_group
      request :delete_security_group
      request :get_security_group
      request :list_security_groups

      # Security Group Rules
      request :create_security_group_rule
      request :delete_security_group_rule
      request :get_security_group_rule
      request :list_security_group_rules

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
            network_id = Fog::UUID.uuid
            subnet_id  = Fog::UUID.uuid
            tenant_id  = Fog::Mock.random_hex(8)

            hash[key] = {
              :networks => {
                network_id => {
                  'id'                    => network_id,
                  'name'                  => 'Public',
                  'subnets'               => [subnet_id],
                  'shared'                => true,
                  'status'                => 'ACTIVE',
                  'tenant_id'             => tenant_id,
                  'provider_network_type' => 'vlan',
                  'router:external'       => false,
                  'admin_state_up'        => true,
                }
              },
              :ports => {},
              :subnets => {
                subnet_id => {
                  'id'               => subnet_id,
                  'name'             => "Public",
                  'network_id'       => network_id,
                  'cidr'             => "192.168.0.0/22",
                  'ip_version'       => 4,
                  'gateway_ip'       => Fog::Mock.random_ip,
                  'allocation_pools' => [],
                  'dns_nameservers'  => [Fog::Mock.random_ip, Fog::Mock.random_ip],
                  'host_routes'      => [Fog::Mock.random_ip],
                  'enable_dhcp'      => true,
                  'tenant_id'        => tenant_id,
                }
              },
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
                  "tenant_id" => tenant_id,
                  "router" => 10,
                  "port" => 30
                }
              ],
              :security_groups      => {},
              :security_group_rules => {},
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          # deprecate namespaced params
          options.each { |k,v|
            if k =~ /^openstack_/
              Fog::Logger.deprecation(":#{k} is deprecated, please use :#{k.to_s.gsub('openstack_','')} instead.")
            end
          }
          options = Hash[options.map { |k, v| [k.to_s.gsub('openstack_','').to_sym, v] }]

          @username = options[:username]
          @tenant   = options[:tenant]
        end

        def data
          self.class.data["#{@username}-#{@tenant}"]
        end

        def reset_data
          self.class.data.delete("#{@username}-#{@tenant}")
        end

        def credentials
          { :provider                 => 'openstack',
            :auth_url       => @auth_uri.to_s,
            :auth_token     => @auth_token,
            :management_url => @management_url }
        end
      end

      class Real
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          # deprecate namespaced params
          options.each { |k,v|
            if k =~ /^openstack_/
              Fog::Logger.deprecation(":#{k} is deprecated, please use :#{k.to_s.gsub('openstack_','')} instead.")
            end
          }
          options = Hash[options.map { |k, v| [k.to_s.gsub('openstack_','').to_sym, v] }]

          @auth_token = options[:auth_token]

          unless @auth_token
            missing_credentials = Array.new
            @api_key  = options[:api_key]
            @username = options[:username]

            missing_credentials << :api_key  unless @api_key
            missing_credentials << :username unless @username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @tenant               = options[:tenant]
          @auth_uri             = URI.parse(options[:auth_url])
          @management_url       = options[:management_url]
          @must_reauthenticate  = false
          @service_type         = options[:service_type] || ['network']
          @service_name         = options[:service_name]
          @endpoint_type        = options[:endpoint_type] || 'publicURL'
          @region               = options[:region]

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
            :current_user             => @current_user,
            :current_tenant           => @current_tenant,
            :region         => @region }
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
              @must_reauthenticate = true
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if !@management_url || @must_reauthenticate
            options = {
              :tenant   => @tenant,
              :api_key  => @api_key,
              :username => @username,
              :auth_uri => @auth_uri,
              :auth_token => @auth_token,
              :service_type => @service_type,
              :service_name => @service_name,
              :endpoint_type => @endpoint_type,
              :region => @region
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @must_reauthenticate = false
            @auth_token = credentials[:token]
            @management_url = credentials[:server_management_url]
            uri = URI.parse(@management_url)
          else
            @auth_token = @auth_token
            uri = URI.parse(@management_url)
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
