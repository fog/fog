require File.expand_path(File.join(File.dirname(__FILE__), '..', 'openstack'))
require 'fog/compute'
require 'fog/openstack'

module Fog
  module Compute
    class OpenStack < Fog::Service

      requires :openstack_api_key, :openstack_username, :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent, :openstack_compute_service_name, :openstack_tenant

      model_path 'fog/openstack/models/compute'
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers
      model       :meta
      collection  :metadata

      request_path 'fog/openstack/requests/compute'
      request :create_server
      request :delete_image
      request :delete_server
      request :get_flavor_details
      request :get_image_details
      request :get_server_details
      request :list_addresses
      request :list_private_addresses
      request :list_public_addresses
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

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => {
                :images  => {},
                :servers => {}
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
              :servers => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'multi_json'
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
          require 'multi_json'
          @openstack_api_key = options[:openstack_api_key]
          @openstack_username = options[:openstack_username]
          @openstack_tenant = options[:openstack_tenant]
          @openstack_compute_service_name = options[:openstack_compute_service_name] || 'nova'
          @openstack_auth_url = options[:openstack_auth_url]
          @openstack_auth_token = options[:openstack_auth_token]
          @openstack_management_url = options[:openstack_management_url]
          @openstack_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}
          authenticate
          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
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
              :path     => "#{@path}/#{params[:path]}",
              :query    => ('ignore_awful_caching' << Time.now.to_i.to_s)
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
              Fog::Compute::OpenStack::NotFound.slurp(error)
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
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_url => @openstack_auth_url,
              :openstack_tenant => @openstack_tenant,
              :openstack_compute_service_name => @openstack_compute_service_name
            }
            if @openstack_auth_url =~ /\/v2.0\//
              credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)
            else
              credentials = Fog::OpenStack.authenticate_v1(options, @connection_options)
            end
            @auth_token = credentials[:token]
            url = credentials[:server_management_url]
            uri = URI.parse(url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end
          @host   = uri.host
          @path   = uri.path
          @path.sub!(/\/$/, '')
          unless @path.match(/1\.1/)
            raise Fog::Compute::OpenStack::ServiceUnavailable.new(
                    "OpenStack binding only supports version 1.1")
          end
          # Add tenant
          @path += @openstack_tenant if @openstack_tenant
          @port   = uri.port
          @scheme = uri.scheme
        end

      end
    end
  end
end
