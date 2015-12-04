require 'fog/openstack/core'

module Fog
  module Network
    class OpenStack < Fog::Service
      SUPPORTED_VERSIONS = /v2(\.0)*/

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_service_type, :openstack_service_name,
                 :openstack_tenant, :openstack_tenant_id,
                 :openstack_api_key, :openstack_username, :openstack_identity_endpoint,
                 :current_user, :current_tenant, :openstack_region,
                 :openstack_endpoint_type,
                 :openstack_project_name, :openstack_project_id,
                 :openstack_project_domain, :openstack_user_domain, :openstack_domain_name,
                 :openstack_project_domain_id, :openstack_user_domain_id, :openstack_domain_id,
                 :openstack_identity_prefix

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

        include Fog::OpenStack::Core

        def initialize(options={})
          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          initialize_identity options
        end

        def data
          self.class.data["#{@openstack_username}-#{@openstack_tenant}"]
        end

        def reset_data
          self.class.data.delete("#{@openstack_username}-#{@openstack_tenant}")
        end

      end

      class Real

        include Fog::OpenStack::Core

        def initialize(options={})
          initialize_identity options

          @openstack_service_type = options[:openstack_service_type] || ['network']
          @openstack_service_name = options[:openstack_service_name]

          @connection_options     = options[:connection_options] || {}

          authenticate
          set_api_path

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
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
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        def set_api_path
          @path.sub!(/\/$/, '')
          unless @path.match(SUPPORTED_VERSIONS)
            @path = "/" + Fog::OpenStack.get_supported_version(SUPPORTED_VERSIONS,
                                                               @openstack_management_uri,
                                                               @auth_token,
                                                               @connection_options)
          end
        end
      end
    end
  end
end
