require File.expand_path(File.join(File.dirname(__FILE__), '..', 'openstack'))
require 'fog/compute'
require 'fog/openstack'

module Fog
  module Compute
    class OpenStack < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_service_name, :openstack_tenant,
                 :openstack_api_key, :openstack_username, :openstack_identity_endpoint

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

      # Metadata
      request :list_metadata
      request :get_metadata
      request :set_metadata
      request :update_metadata
      request :delete_metadata

      # Address
      request :list_addresses
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

      # Volume
      request :list_volumes
      request :create_volume
      request :get_volume_details
      request :delete_volume
      request :attach_volume
      request :detach_volume

      request :create_volume_snapshot
      request :list_snapshots
      request :get_snapshot_details
      request :delete_snapshot

      # Usage
      request :list_usages

      class Mock

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
                "1" => {
                  'id'        => "1",
                  'name'      => "img1",
                  'progress'  => 100,
                  'status'    => "ACTIVE",
                  'updated'   => "",
                  'minRam'    => 0,
                  'minDisk'   => 0,
                  'metadata'  => {},
                  'links'     => []
                }
              },
              :servers => {},
              :key_pairs => {},
              :security_groups => {},
              :addresses => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openstack_username = options[:openstack_username]
        end

        def data
          self.class.data[@openstack_username]
        end

        def reset_data
          self.class.data.delete(@openstack_username)
        end

      end

      class Real
        attr_reader :auth_token

        def initialize(options={})
          @openstack_auth_token = options[:openstack_auth_token]
          @openstack_identity_public_endpoint = options[:openstack_identity_endpoint]

          unless @openstack_auth_token
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
          @openstack_service_name = options[:openstack_service_name] || ['nova', 'compute']
          @openstack_identity_service_name = options[:openstack_identity_service_name] || 'identity'

          @connection_options = options[:connection_options] || {}

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
            :openstack_identity_endpoint => @openstack_identity_public_endpoint }
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{@tenant_id}/#{params[:path]}",
              :query    => params[:query] || ('ignore_awful_caching' << Time.now.to_i.to_s)
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

          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end

          response
        end

        private

        def authenticate
          if @openstack_must_reauthenticate || @openstack_auth_token.nil?
            options = {
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_token => @openstack_auth_token,
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_tenant   => @openstack_tenant,
              :openstack_service_name => @openstack_service_name,
              :openstack_identity_service_name => @openstack_identity_service_name
            }

            if @openstack_auth_uri.path =~ /\/v2.0\//
              credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)
            else
              credentials = Fog::OpenStack.authenticate_v1(options, @connection_options)
            end

            @openstack_must_reauthenticate = false
            @auth_token               = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            @openstack_identity_public_endpoint  = credentials[:identity_public_endpoint]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end

          @host   = uri.host
          @path, @tenant_id = uri.path.scan(/(\/.*)\/(.*)/).flatten
          @port   = uri.port
          @scheme = uri.scheme
          @identity_connection = Fog::Connection.new(
            @openstack_identity_public_endpoint,
            false, @connection_options)
          true
        end

      end
    end
  end
end
