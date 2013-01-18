require 'fog/cloudstack'
require 'fog/compute'
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
      model :zone
      collection :zones

      request :acquire_ip_address
      request :assign_to_load_balancer_rule
      request :assign_virtual_machine
      request :attach_volume
      request :authorize_security_group_egress
      request :authorize_security_group_ingress
      request :change_service_for_virtual_machine
      request :create_account
      request :create_domain
      request :create_load_balancer_rule
      request :create_network
      request :create_port_forwarding_rule
      request :create_security_group
      request :create_ssh_key_pair
      request :create_snapshot
      request :create_snapshot_policy
      request :create_user
      request :create_volume
      request :create_zone
      request :delete_account
      request :delete_domain
      request :delete_load_balancer_rule
      request :delete_port_forwarding_rule
      request :delete_security_group
      request :delete_ssh_key_pair
      request :delete_snapshot
      request :delete_snapshot_policies
      request :delete_template
      request :delete_user
      request :delete_volume
      request :detach_volume
      request :deploy_virtual_machine
      request :destroy_virtual_machine
      request :disable_user
      request :enable_user
      request :generate_usage_records
      request :get_vm_password
      request :list_accounts
      request :list_alerts
      request :list_async_jobs
      request :list_capacity
      request :list_capabilities
      request :list_clusters
      request :list_configurations
      request :list_disk_offerings
      request :list_capacity
      request :list_domains
      request :list_domain_children
      request :list_events
      request :list_external_firewalls
      request :list_external_load_balancers
      request :list_firewall_rules
      request :list_hosts
      request :list_hypervisors
      request :list_instance_groups
      request :list_isos
      request :list_load_balancer_rules
      request :list_load_balancer_rule_instances
      request :list_network_offerings
      request :list_networks
      request :list_os_categories
      request :list_os_types
      request :list_pods
      request :list_port_forwarding_rules
      request :list_public_ip_addresses
      request :list_resource_limits
      request :list_security_groups
      request :list_service_offerings
      request :list_snapshots
      request :list_snapshot_policies
      request :list_ssh_key_pairs
      request :list_storage_pools
      request :list_templates
      request :list_usage_records
      request :list_users
      request :list_virtual_machines
      request :list_volumes
      request :list_zones
      request :migrate_virtual_machine
      request :query_async_job_result
      request :reboot_virtual_machine
      request :recover_virtual_machine
      request :register_ssh_key_pair
      request :register_user_keys
      request :register_template
      request :remove_from_load_balancer_rule
      request :reset_password_for_virtual_machine
      request :revoke_security_group_ingress
      request :revoke_security_group_egress
      request :start_virtual_machine      
      request :stop_virtual_machine
      request :update_account
      request :update_domain
      request :update_user
      request :update_resource_count
      request :update_virtual_machine

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
              :volumes         => {},
              :security_groups => {},
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
