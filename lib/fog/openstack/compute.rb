require File.expand_path(File.join(File.dirname(__FILE__), '..', 'openstack'))
require 'fog/compute'
require 'fog/openstack'

module Fog
  module Compute
    class OpenStack < Fog::Service

      requires :openstack_api_key, :openstack_username, :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_compute_service_name, :openstack_tenant

      model_path 'fog/openstack/models/compute'
      model       :address
      collection  :addresses
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers
      model       :meta
      collection  :metadata
      model       :key_pair
      collection  :key_pairs
      model       :security_group
      collection  :security_groups
      model       :tenant
      collection  :tenants


      request_path 'fog/openstack/requests/compute'
      request :create_server
      request :delete_image
      request :delete_server
      request :get_flavor_details
      request :get_image_details
      request :get_server_details

      request :list_flavors
      request :list_flavors_detail
      request :list_images
      request :list_images_detail
      request :list_servers
      request :list_servers_detail


      request :server_action
      request :change_password_server
      request :reboot_server
      request :rebuild_server
      request :resize_server
      request :confirm_resized_server
      request :revert_resized_server
      request :create_image

      request :update_server

      request :set_metadata
      request :update_metadata
      request :list_metadata

      request :get_meta
      request :update_meta
      request :delete_meta

      request :list_all_addresses
      request :list_private_addresses
      request :list_public_addresses
      request :allocate_address
      request :associate_address
      request :disassociate_address
      request :get_address
      request :list_addresses
      request :release_address

      request :create_security_group
      request :create_security_group_rule
      request :delete_security_group
      request :delete_security_group_rule
      request :list_security_groups
      request :get_security_group

      request :create_key_pair
      request :delete_key_pair
      request :list_key_pairs

      request :list_tenants
      request :set_tenant

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

        def initialize(options={})
          @openstack_api_key  = options[:openstack_api_key]
          @openstack_username = options[:openstack_username]
          @openstack_tenant   = options[:openstack_tenant]
          @openstack_auth_uri   = URI.parse(options[:openstack_auth_url])
          @openstack_auth_token = options[:openstack_auth_token]
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_compute_service_name = options[:openstack_compute_service_name] || ['nova', 'compute']

          @connection_options = options[:connection_options] || {}

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          @identity_connection = Fog::Connection.new(
            "#{@openstack_auth_uri.scheme}://#{@openstack_auth_uri.host}:#{@openstack_auth_uri.port}",
            false, @connection_options)
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
              :query    => ('ignore_awful_caching' << Time.now.to_i.to_s)
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
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_tenant   => @openstack_tenant,
              :openstack_compute_service_name => @openstack_compute_service_name
            }

            if @openstack_auth_uri.path =~ /\/v2.0\//
              credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)
            else
              credentials = Fog::OpenStack.authenticate_v1(options, @connection_options)
            end

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end

          @host   = uri.host
          @path, @tenant_id = uri.path.scan(/(\/.*)\/(.*)/).flatten
          @port   = uri.port
          @scheme = uri.scheme
          true
        end

      end
    end
  end
end
