require 'fog/cloudstack/core'
require 'digest/md5'

module Fog
  module Compute
    class Cloudstack < Fog::Service

      class BadRequest < Fog::Compute::Cloudstack::Error; end
      class Unauthorized < Fog::Compute::Cloudstack::Error; end

      requires :cloudstack_host

      recognizes :cloudstack_api_key, :cloudstack_secret_access_key, :cloudstack_session_key, :cloudstack_session_id,
                 :cloudstack_port, :cloudstack_path, :cloudstack_scheme, :cloudstack_persistent

      request_path 'fog/cloudstack/requests/compute'


      model_path 'fog/cloudstack/models/compute'
      model :address
      model :disk_offering
      collection :disk_offerings
      model :flavor
      collection :flavors
      model :job
      collection :jobs
      model :server
      collection :servers
      model :image
      collection :images
      model :security_group
      collection :security_groups
      model :security_group_rule
      collection :security_group_rules
      model :volume
      collection :volumes
      model :snapshot
      collection :snapshots
      model :zone
      collection :zones

      request :create_network_offering
      request :update_network_offering
      request :delete_network_offering
      request :list_network_offerings
      request :create_network
      request :delete_network
      request :list_networks
      request :restart_network
      request :update_network
      request :create_physical_network
      request :delete_physical_network
      request :list_physical_networks
      request :update_physical_network
      request :list_supported_network_services
      request :add_network_service_provider
      request :delete_network_service_provider
      request :list_network_service_providers
      request :update_network_service_provider
      request :create_storage_network_ip_range
      request :delete_storage_network_ip_range
      request :list_storage_network_ip_range
      request :update_storage_network_ip_range
      request :add_network_device
      request :list_network_device
      request :delete_network_device
      request :create_network_acl
      request :delete_network_acl
      request :list_network_acls
      request :list_nicira_nvp_device_networks
      request :create_vpc
      request :list_vpcs
      request :delete_vpc
      request :update_vpc
      request :restart_vpc
      request :create_vpcoffering
      request :update_vpcoffering
      request :delete_vpcoffering
      request :list_vpcofferings
      request :create_private_gateway
      request :list_private_gateways
      request :delete_private_gateway
      request :create_static_route
      request :delete_static_route
      request :list_static_routes
      request :deploy_virtual_machine
      request :destroy_virtual_machine
      request :reboot_virtual_machine
      request :start_virtual_machine
      request :stop_virtual_machine
      request :reset_password_for_virtual_machine
      request :change_service_for_virtual_machine
      request :update_virtual_machine
      request :recover_virtual_machine
      request :list_virtual_machines
      request :get_vmpassword
      request :migrate_virtual_machine
      request :assign_virtual_machine
      request :restore_virtual_machine
      request :create_remote_access_vpn
      request :delete_remote_access_vpn
      request :list_remote_access_vpns
      request :create_vpn_customer_gateway
      request :create_vpn_gateway
      request :create_vpn_connection
      request :delete_vpn_customer_gateway
      request :delete_vpn_gateway
      request :delete_vpn_connection
      request :update_vpn_customer_gateway
      request :reset_vpn_connection
      request :list_vpn_customer_gateways
      request :list_vpn_gateways
      request :list_vpn_connections
      request :add_traffic_type
      request :delete_traffic_type
      request :list_traffic_types
      request :update_traffic_type
      request :list_traffic_type_implementors
      request :generate_usage_records
      request :list_usage_records
      request :list_usage_types
      request :add_traffic_monitor
      request :delete_traffic_monitor
      request :list_traffic_monitors
      request :create_user
      request :delete_user
      request :update_user
      request :list_users
      request :disable_user
      request :enable_user
      request :get_user
      request :add_vpn_user
      request :remove_vpn_user
      request :list_vpn_users
      request :create_load_balancer_rule
      request :delete_load_balancer_rule
      request :remove_from_load_balancer_rule
      request :assign_to_load_balancer_rule
      request :create_lbstickiness_policy
      request :delete_lbstickiness_policy
      request :list_load_balancer_rules
      request :list_lbstickiness_policies
      request :list_load_balancer_rule_instances
      request :update_load_balancer_rule
      request :create_template
      request :update_template
      request :copy_template
      request :delete_template
      request :list_templates
      request :update_template_permissions
      request :list_template_permissions
      request :extract_template
      request :prepare_template
      request :start_router
      request :reboot_router
      request :stop_router
      request :destroy_router
      request :change_service_for_router
      request :list_routers
      request :create_virtual_router_element
      request :configure_virtual_router_element
      request :list_virtual_router_elements
      request :create_project
      request :delete_project
      request :update_project
      request :activate_project
      request :suspend_project
      request :list_projects
      request :list_project_invitations
      request :update_project_invitation
      request :delete_project_invitation
      request :attach_iso
      request :detach_iso
      request :list_isos
      request :update_iso
      request :delete_iso
      request :copy_iso
      request :update_iso_permissions
      request :list_iso_permissions
      request :extract_iso
      request :add_host
      request :reconnect_host
      request :update_host
      request :delete_host
      request :prepare_host_for_maintenance
      request :cancel_host_maintenance
      request :list_hosts
      request :add_secondary_storage
      request :update_host_password
      request :create_account
      request :delete_account
      request :update_account
      request :disable_account
      request :enable_account
      request :list_accounts
      request :add_account_to_project
      request :delete_account_from_project
      request :list_project_accounts
      request :attach_volume
      request :upload_volume
      request :detach_volume
      request :create_volume
      request :delete_volume
      request :list_volumes
      request :extract_volume
      request :migrate_volume
      request :start_system_vm
      request :reboot_system_vm
      request :stop_system_vm
      request :destroy_system_vm
      request :list_system_vms
      request :migrate_system_vm
      request :change_service_for_system_vm
      request :create_security_group
      request :delete_security_group
      request :authorize_security_group_ingress
      request :revoke_security_group_ingress
      request :authorize_security_group_egress
      request :revoke_security_group_egress
      request :list_security_groups
      request :list_storage_pools
      request :create_storage_pool
      request :update_storage_pool
      request :delete_storage_pool
      request :enable_storage_maintenance
      request :cancel_storage_maintenance
      request :create_snapshot
      request :list_snapshots
      request :delete_snapshot
      request :create_snapshot_policy
      request :delete_snapshot_policies
      request :list_snapshot_policies
      request :list_port_forwarding_rules
      request :create_port_forwarding_rule
      request :delete_port_forwarding_rule
      request :create_firewall_rule
      request :delete_firewall_rule
      request :list_firewall_rules
      request :mark_default_zone_for_account
      request :create_zone
      request :update_zone
      request :delete_zone
      request :list_zones
      request :enable_static_nat
      request :create_ip_forwarding_rule
      request :delete_ip_forwarding_rule
      request :list_ip_forwarding_rules
      request :disable_static_nat
      request :create_domain
      request :update_domain
      request :delete_domain
      request :list_domains
      request :list_domain_children
      request :update_configuration
      request :list_configurations
      request :list_capabilities
      request :update_hypervisor_capabilities
      request :list_hypervisor_capabilities
      request :create_instance_group
      request :delete_instance_group
      request :update_instance_group
      request :list_instance_groups
      request :create_service_offering
      request :delete_service_offering
      request :update_service_offering
      request :list_service_offerings
      request :register_template
      request :register_iso
      request :register_user_keys
      request :register_sshkey_pair
      request :create_pod
      request :update_pod
      request :delete_pod
      request :list_pods
      request :create_disk_offering
      request :update_disk_offering
      request :delete_disk_offering
      request :list_disk_offerings
      request :add_cluster
      request :delete_cluster
      request :update_cluster
      request :list_clusters
      request :create_vlan_ip_range
      request :delete_vlan_ip_range
      request :list_vlan_ip_ranges
      request :create_sshkey_pair
      request :delete_sshkey_pair
      request :list_sshkey_pairs
      request :create_tags
      request :delete_tags
      request :list_tags
      request :add_nicira_nvp_device
      request :delete_nicira_nvp_device
      request :list_nicira_nvp_devices
      request :update_resource_limit
      request :update_resource_count
      request :list_resource_limits
      request :associate_ip_address
      request :disassociate_ip_address
      request :list_public_ip_addresses
      request :add_swift
      request :list_swifts
      request :ldap_config
      request :ldap_remove
      request :list_os_types
      request :list_os_categories
      request :list_events
      request :list_event_types
      request :query_async_job_result
      request :list_async_jobs
      request :list_capacity
      request :logout
      request :login
      request :list_hypervisors
      request :get_cloud_identifier
      request :upload_custom_certificate
      request :list_alerts
      request :create_network_offering
      request :update_network_offering
      request :delete_network_offering
      request :list_network_offerings
      request :create_network_offering
      request :update_network_offering
      request :delete_network_offering
      request :create_network_offering
      request :update_network_offering
      request :delete_network_offering
      request :list_network_offerings
      request :create_network
      request :delete_network
      request :list_networks
      request :restart_network
      request :update_network
      request :create_physical_network
      request :delete_physical_network
      request :list_physical_networks
      request :update_physical_network
      request :list_supported_network_services
      request :add_network_service_provider
      request :delete_network_service_provider
      request :list_network_service_providers
      request :update_network_service_provider
      request :create_storage_network_ip_range
      request :delete_storage_network_ip_range
      request :list_storage_network_ip_range
      request :update_storage_network_ip_range
      request :add_network_device
      request :list_network_device
      request :delete_network_device
      request :create_network_acl
      request :delete_network_acl
      request :list_network_acls
      request :list_nicira_nvp_device_networks
      request :create_vpc
      request :list_vpcs
      request :delete_vpc
      request :update_vpc
      request :restart_vpc
      request :create_vpcoffering
      request :update_vpcoffering
      request :delete_vpcoffering
      request :list_vpcofferings
      request :create_private_gateway
      request :list_private_gateways
      request :delete_private_gateway
      request :create_static_route
      request :delete_static_route
      request :list_static_routes
      request :deploy_virtual_machine
      request :destroy_virtual_machine
      request :reboot_virtual_machine
      request :start_virtual_machine
      request :stop_virtual_machine
      request :reset_password_for_virtual_machine
      request :change_service_for_virtual_machine
      request :update_virtual_machine
      request :recover_virtual_machine
      request :list_virtual_machines
      request :get_vmpassword
      request :migrate_virtual_machine
      request :assign_virtual_machine
      request :restore_virtual_machine
      request :create_remote_access_vpn
      request :delete_remote_access_vpn
      request :list_remote_access_vpns
      request :create_vpn_customer_gateway
      request :create_vpn_gateway
      request :create_vpn_connection
      request :delete_vpn_customer_gateway
      request :delete_vpn_gateway
      request :delete_vpn_connection
      request :update_vpn_customer_gateway
      request :reset_vpn_connection
      request :list_vpn_customer_gateways
      request :list_vpn_gateways
      request :list_vpn_connections
      request :add_traffic_type
      request :delete_traffic_type
      request :list_traffic_types
      request :update_traffic_type
      request :list_traffic_type_implementors
      request :generate_usage_records
      request :list_usage_records
      request :list_usage_types
      request :add_traffic_monitor
      request :delete_traffic_monitor
      request :list_traffic_monitors
      request :create_user
      request :delete_user
      request :update_user
      request :list_users
      request :disable_user
      request :enable_user
      request :get_user
      request :add_vpn_user
      request :remove_vpn_user
      request :list_vpn_users
      request :create_load_balancer_rule
      request :delete_load_balancer_rule
      request :remove_from_load_balancer_rule
      request :assign_to_load_balancer_rule
      request :create_lbstickiness_policy
      request :delete_lbstickiness_policy
      request :list_load_balancer_rules
      request :list_lbstickiness_policies
      request :list_load_balancer_rule_instances
      request :update_load_balancer_rule
      request :create_template
      request :update_template
      request :copy_template
      request :delete_template
      request :list_templates
      request :update_template_permissions
      request :list_template_permissions
      request :extract_template
      request :prepare_template
      request :start_router
      request :reboot_router
      request :stop_router
      request :destroy_router
      request :change_service_for_router
      request :list_routers
      request :create_virtual_router_element
      request :configure_virtual_router_element
      request :list_virtual_router_elements
      request :create_project
      request :delete_project
      request :update_project
      request :activate_project
      request :suspend_project
      request :list_projects
      request :list_project_invitations
      request :update_project_invitation
      request :delete_project_invitation
      request :attach_iso
      request :detach_iso
      request :list_isos
      request :update_iso
      request :delete_iso
      request :copy_iso
      request :update_iso_permissions
      request :list_iso_permissions
      request :extract_iso
      request :add_host
      request :reconnect_host
      request :update_host
      request :delete_host
      request :prepare_host_for_maintenance
      request :cancel_host_maintenance
      request :list_hosts
      request :add_secondary_storage
      request :update_host_password
      request :create_account
      request :delete_account
      request :update_account
      request :disable_account
      request :enable_account
      request :list_accounts
      request :add_account_to_project
      request :delete_account_from_project
      request :list_project_accounts
      request :attach_volume
      request :upload_volume
      request :detach_volume
      request :create_volume
      request :delete_volume
      request :list_volumes
      request :extract_volume
      request :migrate_volume
      request :start_system_vm
      request :reboot_system_vm
      request :stop_system_vm
      request :destroy_system_vm
      request :list_system_vms
      request :migrate_system_vm
      request :change_service_for_system_vm
      request :create_security_group
      request :delete_security_group
      request :authorize_security_group_ingress
      request :revoke_security_group_ingress
      request :authorize_security_group_egress
      request :revoke_security_group_egress
      request :list_security_groups
      request :list_storage_pools
      request :create_storage_pool
      request :update_storage_pool
      request :delete_storage_pool
      request :enable_storage_maintenance
      request :cancel_storage_maintenance
      request :create_snapshot
      request :list_snapshots
      request :delete_snapshot
      request :create_snapshot_policy
      request :delete_snapshot_policies
      request :list_snapshot_policies
      request :list_port_forwarding_rules
      request :create_port_forwarding_rule
      request :delete_port_forwarding_rule
      request :create_firewall_rule
      request :delete_firewall_rule
      request :list_firewall_rules
      request :mark_default_zone_for_account
      request :create_zone
      request :update_zone
      request :delete_zone
      request :list_zones
      request :enable_static_nat
      request :create_ip_forwarding_rule
      request :delete_ip_forwarding_rule
      request :list_ip_forwarding_rules
      request :disable_static_nat
      request :create_domain
      request :update_domain
      request :delete_domain
      request :list_domains
      request :list_domain_children
      request :update_configuration
      request :list_configurations
      request :list_capabilities
      request :update_hypervisor_capabilities
      request :list_hypervisor_capabilities
      request :create_instance_group
      request :delete_instance_group
      request :update_instance_group
      request :list_instance_groups
      request :create_service_offering
      request :delete_service_offering
      request :update_service_offering
      request :list_service_offerings
      request :register_template
      request :register_iso
      request :register_user_keys
      request :register_sshkey_pair
      request :create_pod
      request :update_pod
      request :delete_pod
      request :list_pods
      request :create_disk_offering
      request :update_disk_offering
      request :delete_disk_offering
      request :list_disk_offerings
      request :add_cluster
      request :delete_cluster
      request :update_cluster
      request :list_clusters
      request :create_vlan_ip_range
      request :delete_vlan_ip_range
      request :list_vlan_ip_ranges
      request :create_sshkey_pair
      request :delete_sshkey_pair
      request :list_sshkey_pairs
      request :create_tags
      request :delete_tags
      request :list_tags
      request :add_nicira_nvp_device
      request :delete_nicira_nvp_device
      request :list_nicira_nvp_devices
      request :update_resource_limit
      request :update_resource_count
      request :list_resource_limits
      request :associate_ip_address
      request :disassociate_ip_address
      request :list_public_ip_addresses
      request :add_swift
      request :list_swifts
      request :ldap_config
      request :ldap_remove
      request :list_os_types
      request :list_os_categories
      request :list_events
      request :list_event_types
      request :query_async_job_result
      request :list_async_jobs
      request :list_capacity
      request :logout
      request :login
      request :list_hypervisors
      request :get_cloud_identifier
      request :upload_custom_certificate
      request :list_alerts


      class Real

        def initialize(options={})
          @cloudstack_api_key           = options[:cloudstack_api_key]
          @cloudstack_secret_access_key = options[:cloudstack_secret_access_key]
          @cloudstack_session_id        = options[:cloudstack_session_id]
          @cloudstack_session_key       = options[:cloudstack_session_key]
          @host                         = options[:cloudstack_host]
          @path                         = options[:cloudstack_path]    || '/client/api'
          @port                         = options[:cloudstack_port]    || 443
          @scheme                       = options[:cloudstack_scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", options[:cloudstack_persistent], {:ssl_verify_peer => false})
        end

        def reload
          @connection.reset
        end

        def login(username,password,domain)
          response = issue_request({
            'response' => 'json',
            'command'  => 'login',
            'username' => username,
            'password' => Digest::MD5.hexdigest(password),
            'domain'   => domain
          })

          # Parse response cookies to retrive JSESSIONID token
          cookies   = CGI::Cookie.parse(response.headers['Set-Cookie'])
          sessionid = cookies['JSESSIONID'].first

          # Decode the login response
          response   = Fog::JSON.decode(response.body)

          user = response['loginresponse']
          user.merge!('sessionid' => sessionid)

          @cloudstack_session_id  = user['sessionid']
          @cloudstack_session_key = user['sessionkey']

          user
        end

        def request(params)
          params.reject!{|k,v| v.nil?}

          params.merge!('response' => 'json')

          if has_session?
            params, headers = authorize_session(params)
          elsif has_keys?
            params, headers = authorize_api_keys(params)
          end

          response = issue_request(params,headers)
          response = Fog::JSON.decode(response.body) unless response.body.empty?

          response
        end

      private
        def has_session?
          @cloudstack_session_id && @cloudstack_session_key
        end

        def has_keys?
          @cloudstack_api_key && @cloudstack_secret_access_key
        end

        def authorize_session(params)
          # set the session id cookie for the request
          headers = {'Cookie' => "JSESSIONID=#{@cloudstack_session_id};"}
          # set the sesion key for the request, params are not signed using session auth
          params.merge!('sessionkey' => @cloudstack_session_key)

          return params, headers
        end

        def authorize_api_keys(params)
          headers = {}
          # merge the api key into the params
          params.merge!('apiKey' => @cloudstack_api_key)
          # sign the request parameters
          signature = Fog::Cloudstack.signed_params(@cloudstack_secret_access_key,params)
          # merge signature into request param
          params.merge!({'signature' => signature})

          return params, headers
        end

        def issue_request(params={},headers={},method='GET',expects=200)
          begin
            @connection.request({
              :query => params,
              :headers => headers,
              :method => method,
              :expects => expects  
            })

          rescue Excon::Errors::HTTPStatusError => error
            error_response = Fog::JSON.decode(error.response.body)
            error_code = error_response.values.first['errorcode']
            error_text = error_response.values.first['errortext']

            case error_code
            when 401
              raise Fog::Compute::Cloudstack::Unauthorized, error_text
            when 431
              raise Fog::Compute::Cloudstack::BadRequest, error_text
            else
              raise Fog::Compute::Cloudstack::Error, error_text
            end
          end

        end
      end # Real

      class Mock
        def initialize(options={})
          @cloudstack_api_key = options[:cloudstack_api_key]
        end

        def self.data
          @data ||= begin
            zone_id     = Fog.credentials[:cloudstack_zone_id]             || Fog::Cloudstack.uuid
            image_id    = Fog.credentials[:cloudstack_template_id]         || Fog::Cloudstack.uuid
            flavor_id   = Fog.credentials[:cloudstack_service_offering_id] || Fog::Cloudstack.uuid
            network_id  = (Array(Fog.credentials[:cloudstack_network_ids]) || [Fog::Cloudstack.uuid]).first
            domain_name = "exampleorg"
            account_id, user_id, domain_id = Fog::Cloudstack.uuid, Fog::Cloudstack.uuid, Fog::Cloudstack.uuid
            domain = {
              "id"               => domain_id,
              "name"             => domain_name,
              "level"            => 1,
              "parentdomainid"   => Fog::Cloudstack.uuid,
              "parentdomainname" => "ROOT",
              "haschild"         => false,
              "path"             => "ROOT/accountname"
            }
            user = {
              "id"          => user_id,
              "username"    => "username",
              "firstname"   => "Bob",
              "lastname"    => "Lastname",
              "email"       => "email@example.com",
              "created"     => "2012-05-14T16:25:17-0500",
              "state"       => "enabled",
              "account"     => "accountname",
              "accounttype" => 2,
              "domainid"    => domain_id,
              "domain"      => domain_name,
              "apikey"      => Fog::Cloudstack.uuid,
              "secretkey"   => Fog::Cloudstack.uuid
            }
            {
              :users    => { user_id    => user },
              :networks => { network_id => {
                "id"                          => network_id,
                "name"                        => "10.56.23.0/26",
                "displaytext"                 => "10.56.23.0/26",
                "broadcastdomaintype"         => "Vlan",
                "traffictype"                 => "Guest",
                "gateway"                     => "10.56.23.1",
                "netmask"                     => "255.255.255.192",
                "cidr"                        => "10.56.23.0/26",
                "zoneid"                      => zone_id,
                "zonename"                    => "zone-00",
                "networkofferingid"           => "af0c9bd5-a1b2-4ad0-bf4b-d6fa9b1b9d5b",
                "networkofferingname"         => "DefaultSharedNetworkOffering",
                "networkofferingdisplaytext"  => "Offering for Shared networks",
                "networkofferingavailability" => "Optional",
                "issystem"                    => false,
                "state"                       => "Setup",
                "related"                     => "86bbc9fc-d92e-49db-9fdc-296189090017",
                "broadcasturi"                => "vlan://800",
                "dns1"                        => "10.0.80.11",
                "type"                        => "Shared",
                "vlan"                        => "800",
                "acltype"                     => "Domain",
                "subdomainaccess"             => true,
                "domainid"                    => domain_id,
                "domain"                      => "ROOT",
                "service" => [
                  {"name" => "UserData"},
                  {"name" => "Dhcp"},
                  {
                    "name"       => "Dns",
                    "capability" => [
                      {
                        "name"                       => "AllowDnsSuffixModification",
                        "value"                      => "true",
                        "canchooseservicecapability" => false
                      }
                    ]
                }],
                "networkdomain"     => "cs1cloud.internal",
                "physicalnetworkid" => "8f4627c5-1fdd-4504-8a92-f61b4e9cb3e3",
                "restartrequired"   => false,
                "specifyipranges"   => true}
              },
              :zones => { zone_id => {
                "id"                    => zone_id,
                "name"                  => "zone-00",
                "domainid"              => 1,
                "domainname"            => "ROOT",
                "networktype"           => "Advanced",
                "securitygroupsenabled" => false,
                "allocationstate"       => "Enabled",
                "zonetoken"             => Fog::Cloudstack.uuid,
                "dhcpprovider"          => "VirtualRouter"}},
              :images => { image_id => {
                "id"              => image_id,
                "name"            => "CentOS 5.6(64-bit) no GUI (XenServer)",
                "displaytext"     => "CentOS 5.6(64-bit) no GUI (XenServer)",
                "ispublic"        => true,
                "created"         => "2012-05-09T15:29:33-0500",
                "isready"         => true,
                "passwordenabled" => false,
                "format"          => "VHD",
                "isfeatured"      => true,
                "crossZones"      => true,
                "ostypeid"        => "a6a6694a-18f5-4765-8418-2b7a5f37cd0f",
                "ostypename"      => "CentOS 5.3 (64-bit)",
                "account"         => "system",
                "zoneid"          => zone_id,
                "zonename"        => "zone-00",
                "status"          => "Download Complete",
                "size"            => 21474836480,
                "templatetype"    => "BUILTIN",
                "domain"          => "ROOT",
                "domainid"        => "6023b6fe-5bef-4358-bc76-9f4e75afa52f",
                "isextractable"   => true,
                "checksum"        => "905cec879afd9c9d22ecc8036131a180",
                "hypervisor"      => "Xen"
              }},
              :flavors => { flavor_id => {
                "id"          => flavor_id,
                "name"        => "Medium Instance",
                "displaytext" => "Medium Instance",
                "cpunumber"   => 1,
                "cpuspeed"    => 1000,
                "memory"      => 1024,
                "created"     => "2012-05-09T14:48:36-0500",
                "storagetype" => "shared",
                "offerha"     => false,
                "limitcpuuse" => false,
                "issystem"    => false,
                "defaultuse"  => false}},
              :accounts => { account_id => {
                "id"                => account_id,
                "name"              => "accountname",
                "accounttype"       => 2,
                "domainid"          => domain_id,
                "domain"            => domain_name,
                "receivedbytes"     => 0,
                "sentbytes"         => 0,
                "vmlimit"           => "Unlimited",
                "vmtotal"           => 0,
                "vmavailable"       => "Unlimited",
                "iplimit"           => "Unlimited",
                "iptotal"           => 0,
                "ipavailable"       => "Unlimited",
                "volumelimit"       => "Unlimited",
                "volumetotal"       => 0,
                "volumeavailable"   => "Unlimited",
                "snapshotlimit"     => "Unlimited",
                "snapshottotal"     => 0,
                "snapshotavailable" => "Unlimited",
                "templatelimit"     => "Unlimited",
                "templatetotal"     => 0,
                "templateavailable" => "Unlimited",
                "vmstopped"         => 0,
                "vmrunning"         => 0,
                "projectlimit"      => "Unlimited",
                "projecttotal"      => 1,
                "projectavailable"  => "Unlimited",
                "networklimit"      => "Unlimited",
                "networktotal"      => 0,
                "networkavailable"  => "Unlimited",
                "state"             => "enabled",
                "user"              => [user]}
              },
              :domains         => {domain_id => domain},
              :servers         => {},
              :jobs            => {},
              :volumes         => {
                "89198f7c-0245-aa1d-136a-c5f479ef9db7" => {
                  "id"=> "89198f7c-0245-aa1d-136a-c5f479ef9db7",
                  "name"=>"test volume",
                  "zoneid"=> zone_id,
                  "zonename"=>"zone-00",
                  "type"=>"DATADISK",
                  "deviceid"=>1,
                  "virtualmachineid"=> "51dcffee-5f9f-29a4-acee-2717e1a3656b",
                  "vmname"=>"i-2824-11621-VM",
                  "vmdisplayname"=>"test vm",
                  "vmstate"=>"Running",
                  "size"=>17179869184,
                  "created"=>"2013-04-16T12:33:41+0000",
                  "state"=>"Ready",
                  "account"=> 'accountname',
                  "domainid"=> domain_id,
                  "domain"=> domain_name,
                  "storagetype"=>"shared",
                  "hypervisor"=>"KVM",
                  "diskofferingid"=> "cc4de87d-672d-4353-abb5-6a8a4c0abf59",
                  "diskofferingname"=>"Small Disk",
                  "diskofferingdisplaytext"=>"Small Disk [16GB Disk]",
                  "storage"=>"ps1",
                  "attached"=>"2013-04-16T12:34:07+0000",
                  "destroyed"=>false,
                  "isextractable"=>false
                  },
                },
              :security_groups => {},
              :snapshots       => {},
              :disk_offerings  => {
                "cc4de87d-672d-4353-abb5-6a8a4c0abf59" => {
                  "id"           => "cc4de87d-672d-4353-abb5-6a8a4c0abf59",
                  "domainid"     => domain_id,
                  "domain"       => domain_name,
                  "name"         => "Small Disk",
                  "displaytext"  => "Small Disk [16GB Disk]",
                  "disksize"     => 16,
                  "created"      => "2013-02-21T03:12:520300",
                  "iscustomized" => false,
                  "storagetype"  =>  "shared"
                },
                "d5deeb0c-de03-4ebf-820a-dc74221bcaeb" => {
                  "id"           => "d5deeb0c-de03-4ebf-820a-dc74221bcaeb",
                  "domainid"     => domain_id,
                  "domain"       => domain_name,
                  "name"         => "Medium Disk",
                  "displaytext"  => "Medium Disk [32GB Disk]",
                  "disksize"     => 32,
                  "created"      => "2013-02-21T03:12:520300",
                  "iscustomized" => false,
                  "storagetype"  => "shared"
                }
              },
              :os_types  => {
                "51ef854d-279e-4e68-9059-74980fd7b29b" => {
                  "id"           => "51ef854d-279e-4e68-9059-74980fd7b29b",
                  "oscategoryid" => "56f67279-e082-45c3-a01c-d290d6cd4ce2",
                  "description"  => "Asianux 3(32-bit)"
                  },
                "daf124c8-95d8-4756-8e1c-1871b073babb" => {
                  "id"           => "daf124c8-95d8-4756-8e1c-1871b073babb",
                  "oscategoryid" => "56f67279-e082-45c3-a01c-d290d6cd4ce2",
                  "description"  => "Asianux 3(64-bit)"
                  }
              }
            }
          end
        end

        def self.reset
          @data = nil
        end

        def data
          self.class.data
        end

        def reset_data
          self.class.data.delete(@cloudstack_api_key)
        end
      end
    end # Cloudstack
  end # Compute
end # Fog
