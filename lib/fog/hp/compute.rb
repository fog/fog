require 'fog/hp'
require 'fog/compute'

module Fog
  module Compute
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_account_id, :hp_tenant_id
      recognizes  :hp_auth_uri, :hp_servicenet, :persistent, :connection_options, :hp_use_upass_auth_style, :hp_auth_version, :hp_avl_zone

      secrets     :hp_secret_key

      model_path 'fog/hp/models/compute'
      model       :address
      collection  :addresses
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :key_pair
      collection  :key_pairs
      model       :security_group
      collection  :security_groups
      model       :server
      collection  :servers

      request_path 'fog/hp/requests/compute'
      request :allocate_address
      request :associate_address
      request :change_password_server
      #request :confirm_resized_server
      request :create_image
      request :create_key_pair
      request :create_security_group
      request :create_security_group_rule
      request :create_server
      request :delete_image
      request :delete_key_pair
      request :delete_security_group
      request :delete_security_group_rule
      request :delete_server
      request :disassociate_address
      request :get_address
      request :get_flavor_details
      request :get_image_details
      request :get_security_group
      request :get_server_details
      request :list_addresses
      request :list_flavors
      request :list_flavors_detail
      request :list_images
      request :list_images_detail
      request :list_key_pairs
      request :list_security_groups
      request :list_server_addresses
      request :list_server_private_addresses
      request :list_server_public_addresses
      request :list_servers
      request :list_servers_detail
      request :reboot_server
      request :rebuild_server
      request :release_address
      #request :resize_server
      #request :revert_resized_server
      request :server_action
      request :update_server

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => {
                :images  => {},
                :key_pairs => {},
                :security_groups => {},
                :servers => {},
                :addresses => {}
              },
              :images  => {},
              :key_pairs => {},
              :security_groups => {},
              :servers => {},
              :addresses => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @hp_account_id = options[:hp_account_id]
        end

        def data
          self.class.data[@hp_account_id]
        end

        def reset_data
          self.class.data.delete(@hp_account_id)
        end

      end

      class Real

        def initialize(options={})
          @hp_secret_key = options[:hp_secret_key]
          @hp_account_id = options[:hp_account_id]
          @hp_servicenet = options[:hp_servicenet]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version = options[:hp_auth_version] || :v2
          ### Pass the service type for compute via the options hash
          options[:hp_service_type] = "compute"
          @hp_tenant_id = options[:hp_tenant_id]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the cdn endpoint
            @hp_compute_uri = credentials[:endpoint_url]
          else
            # Call the legacy v1.0/v1.1 authentication
            credentials = Fog::HP.authenticate_v1(options, @connection_options)
            # the user sends in the cdn endpoint
            @hp_compute_uri = options[:hp_auth_uri]
          end

          @auth_token = credentials[:auth_token]

          uri = URI.parse(@hp_compute_uri)
          @host   = @hp_servicenet == true ? "snet-#{uri.host}" : uri.host
          @path   = uri.path
          @persistent = options[:persistent] || false
          @port   = uri.port
          @scheme = uri.scheme
          Excon.ssl_verify_peer = false if options[:hp_servicenet] == true

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
              :query    => ('ignore_awful_caching' << Time.now.to_i.to_s)
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::HP::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            begin
              response.body = Fog::JSON.decode(response.body)
            rescue MultiJson::DecodeError => error
              response.body    #### the body is not in JSON format so just return it as it is
            end
          end
          response
        end

      end
    end
  end
end
