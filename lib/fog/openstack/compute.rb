require 'fog/compute'
require 'fog/openstack'

module Fog
  module Compute
    class OpenStack < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_service_type, :openstack_service_name,
                 :openstack_tenant,
                 :openstack_api_key, :openstack_username, :openstack_identity_endpoint,
                 :current_user, :current_tenant, :openstack_region,
                 :openstack_endpoint_type

      ## MODELS
      #
      model_path 'fog/openstack/models/compute'
      model       :server
      collection  :servers
      model       :image
      collection  :images
      model       :flavor
      collection  :flavors
      model       :metadatum
      collection  :metadata
      model       :address
      collection  :addresses
      model       :security_group
      collection  :security_groups
      model       :key_pair
      collection  :key_pairs
      model       :tenant
      collection  :tenants
      model       :volume
      collection  :volumes
      model       :network
      collection  :networks
      model       :snapshot
      collection  :snapshots
      model       :host
      collection  :hosts

      ## REQUESTS
      #
      request_path 'fog/openstack/requests/compute'

      # Server CRUD
      request :list_servers
      request :list_servers_detail
      request :create_server
      request :get_server_details
      request :update_server
      request :delete_server

      # Server Actions
      request :server_actions
      request :server_action
      request :reboot_server
      request :rebuild_server
      request :resize_server
      request :confirm_resize_server
      request :revert_resize_server
      request :pause_server
      request :unpause_server
      request :suspend_server
      request :resume_server
      request :rescue_server
      request :change_server_password
      request :add_fixed_ip
      request :remove_fixed_ip
      request :server_diagnostics
      request :boot_from_snapshot
      request :reset_server_state

      # Server Extenstions
      request :get_console_output
      request :get_vnc_console
      request :live_migrate_server
      request :migrate_server

      # Image CRUD
      request :list_images
      request :list_images_detail
      request :create_image
      request :get_image_details
      request :delete_image

      # Flavor CRUD
      request :list_flavors
      request :list_flavors_detail
      request :get_flavor_details
      request :create_flavor
      request :delete_flavor

      # Flavor Access
      request :add_flavor_access
      request :remove_flavor_access
      request :list_tenants_with_flavor_access

      # Metadata
      request :list_metadata
      request :get_metadata
      request :set_metadata
      request :update_metadata
      request :delete_metadata

      # Metadatam
      request :delete_meta
      request :update_meta

      # Address
      request :list_addresses
      request :list_address_pools
      request :list_all_addresses
      request :list_private_addresses
      request :list_public_addresses
      request :get_address
      request :allocate_address
      request :associate_address
      request :release_address
      request :disassociate_address

      # Security Group
      request :list_security_groups
      request :get_security_group
      request :create_security_group
      request :create_security_group_rule
      request :delete_security_group
      request :delete_security_group_rule

      # Key Pair
      request :list_key_pairs
      request :create_key_pair
      request :delete_key_pair

      # Tenant
      request :list_tenants
      request :set_tenant
      request :get_limits

      # Volume
      request :list_volumes
      request :create_volume
      request :get_volume_details
      request :delete_volume
      request :attach_volume
      request :detach_volume
      request :get_server_volumes

      request :create_volume_snapshot
      request :list_snapshots
      request :get_snapshot_details
      request :delete_snapshot

      # Usage
      request :list_usages
      request :get_usage

      # Quota
      request :get_quota
      request :get_quota_defaults
      request :update_quota

      # Hosts
      request :list_hosts
      request :get_host_details


      class Mock
        attr_reader :auth_token
        attr_reader :auth_token_expiration
        attr_reader :current_user
        attr_reader :current_tenant

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => {
                :images  => {},
                :servers => {},
                :key_pairs => {},
                :security_groups => {},
                :addresses => {}
              },
              :images  => {
                "0e09fbd6-43c5-448a-83e9-0d3d05f9747e" => {
                  "id"=>"0e09fbd6-43c5-448a-83e9-0d3d05f9747e",
                  "name"=>"cirros-0.3.0-x86_64-blank",
                  'progress'  => 100,
                  'status'    => "ACTIVE",
                  'updated'   => "",
                  'minRam'    => 0,
                  'minDisk'   => 0,
                  'metadata'  => {},
                  'links'     => [{"href"=>"http://nova1:8774/v1.1/admin/images/1", "rel"=>"self"}, {"href"=>"http://nova1:8774/admin/images/2", "rel"=>"bookmark"}]
                }
              },
              :servers => {},
              :key_pairs => {},
              :security_groups => {
                0 => {
                  "id"          => 0,
                  "tenant_id"   => Fog::Mock.random_hex(8),
                  "name"        => "default",
                  "description" => "default",
                  "rules"       => [
                    { "id"              => 0,
                      "parent_group_id" => 0,
                      "from_port"       => 68,
                      "to_port"         => 68,
                      "ip_protocol"     => "udp",
                      "ip_range"        => { "cidr" => "0.0.0.0/0" },
                      "group"           => {}, },
                  ],
                },
              },
              :server_security_group_map => {},
              :addresses => {},
              :quota => {
                'security_group_rules' => 20,
                'security_groups' => 10,
                'injected_file_content_bytes' => 10240,
                'injected_file_path_bytes' => 256,
                'injected_files' => 5,
                'metadata_items' => 128,
                'floating_ips'   => 10,
                'instances'      => 10,
                'key_pairs'      => 10,
                'gigabytes'      => 5000,
                'volumes'        => 10,
                'cores'          => 20,
                'ram'            => 51200
              },
              :volumes => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openstack_username = options[:openstack_username]
          @openstack_auth_uri = URI.parse(options[:openstack_auth_url])

          @current_tenant = options[:openstack_tenant]

          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          management_url = URI.parse(options[:openstack_auth_url])
          management_url.port = 8774
          management_url.path = '/v1.1/1'
          @openstack_management_url = management_url.to_s

          identity_public_endpoint = URI.parse(options[:openstack_auth_url])
          identity_public_endpoint.port = 5000
          @openstack_identity_public_endpoint = identity_public_endpoint.to_s
        end

        def data
          self.class.data["#{@openstack_username}-#{@current_tenant}"]
        end

        def reset_data
          self.class.data.delete("#{@openstack_username}-#{@current_tenant}")
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
            :openstack_identity_endpoint => @openstack_identity_public_endpoint }
        end
      end

      class Real
        attr_reader :auth_token
        attr_reader :auth_token_expiration
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          @openstack_auth_token = options[:openstack_auth_token]
          @auth_token        = options[:openstack_auth_token]
          @openstack_identity_public_endpoint = options[:openstack_identity_endpoint]

          unless @auth_token
            missing_credentials = Array.new
            @openstack_api_key  = options[:openstack_api_key]
            @openstack_username = options[:openstack_username]

            missing_credentials << :openstack_api_key  unless @openstack_api_key
            missing_credentials << :openstack_username unless @openstack_username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @openstack_tenant     = options[:openstack_tenant]
          @openstack_auth_uri   = URI.parse(options[:openstack_auth_url])
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_service_type = options[:openstack_service_type] || ['nova', 'compute']
          @openstack_service_name = options[:openstack_service_name]
          @openstack_identity_service_type = options[:openstack_identity_service_type] || 'identity'
          @openstack_endpoint_type = options[:openstack_endpoint_type] || 'publicURL'
          @openstack_region      = options[:openstack_region]

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
            :openstack_identity_endpoint => @openstack_identity_public_endpoint,
            :openstack_region         => @openstack_region,
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
              :path     => "#{@path}/#{@tenant_id}/#{params[:path]}",
              :query    => params[:query]
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @openstack_must_reauthenticate = true
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

          if !response.body.empty? and response.get_header('Content-Type') == 'application/json'
            response.body = Fog::JSON.decode(response.body)
          end

          response
        end

        private

        def authenticate
          if !@openstack_management_url || @openstack_must_reauthenticate
            options = {
              :openstack_api_key    => @openstack_api_key,
              :openstack_username   => @openstack_username,
              :openstack_auth_token => @auth_token,
              :openstack_auth_uri   => @openstack_auth_uri,
              :openstack_region     => @openstack_region,
              :openstack_tenant     => @openstack_tenant,
              :openstack_service_type => @openstack_service_type,
              :openstack_service_name => @openstack_service_name,
              :openstack_identity_service_type => @openstack_identity_service_type,
              :openstack_endpoint_type => @openstack_endpoint_type
            }

            if @openstack_auth_uri.path =~ /\/v2.0\//

              credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)
            else
              credentials = Fog::OpenStack.authenticate_v1(options, @connection_options)
            end

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token               = credentials[:token]
            @auth_token_expiration    = credentials[:expires]
            @openstack_management_url = credentials[:server_management_url]
            @openstack_identity_public_endpoint  = credentials[:identity_public_endpoint]
          end

          uri = URI.parse(@openstack_management_url)
          @host   = uri.host
          @path, @tenant_id = uri.path.scan(/(\/.*)\/(.*)/).flatten

          @path.sub!(/\/$/, '')
          unless @path.match(/1\.1|v2/)
            raise Fog::OpenStack::Errors::ServiceUnavailable.new(
                    "OpenStack binding only supports version 2 (a.k.a. 1.1)")
          end

          @port   = uri.port
          @scheme = uri.scheme
           
          # Not all implementations have identity service in the catalog
          if @openstack_identity_public_endpoint || @openstack_management_url
            @identity_connection = Fog::Connection.new(
              @openstack_identity_public_endpoint || @openstack_management_url,
              false, @connection_options)
          end

          true
        end

      end
    end
  end
end
