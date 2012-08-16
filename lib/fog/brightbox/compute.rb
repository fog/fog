require 'fog/brightbox'
require 'fog/compute'

module Fog
  module Compute
    class Brightbox < Fog::Service

      API_URL = "https://api.gb1.brightbox.com/"

      requires :brightbox_client_id, :brightbox_secret
      recognizes :brightbox_auth_url, :brightbox_api_url, :persistent

      model_path 'fog/brightbox/models/compute'
      model       :account # Singular resource, no collection
      collection  :servers
      model       :server
      collection  :server_groups
      model       :server_group
      collection  :firewall_policies
      model       :firewall_policy
      collection  :firewall_rules
      model       :firewall_rule
      collection  :flavors
      model       :flavor
      collection  :images
      model       :image
      collection  :load_balancers
      model       :load_balancer
      collection  :zones
      model       :zone
      collection  :cloud_ips
      model       :cloud_ip
      collection  :users
      model       :user

      request_path 'fog/brightbox/requests/compute'
      request :activate_console_server
      request :add_listeners_load_balancer
      request :add_nodes_load_balancer
      request :add_servers_server_group
      request :apply_to_firewall_policy
      request :remove_firewall_policy
      request :create_api_client
      request :create_cloud_ip
      request :create_firewall_policy
      request :create_firewall_rule
      request :create_image
      request :create_load_balancer
      request :create_server
      request :create_server_group
      request :destroy_api_client
      request :destroy_cloud_ip
      request :destroy_firewall_policy
      request :destroy_firewall_rule
      request :destroy_image
      request :destroy_load_balancer
      request :destroy_server
      request :destroy_server_group
      request :get_account
      request :get_api_client
      request :get_cloud_ip
      request :get_firewall_policy
      request :get_firewall_rule
      request :get_image
      request :get_interface
      request :get_load_balancer
      request :get_server
      request :get_server_group
      request :get_server_type
      request :get_user
      request :get_zone
      request :list_api_clients
      request :list_cloud_ips
      request :list_firewall_policies
      request :list_images
      request :list_load_balancers
      request :list_server_groups
      request :list_server_types
      request :list_servers
      request :list_users
      request :list_zones
      request :map_cloud_ip
      request :move_servers_server_group
      request :remove_listeners_load_balancer
      request :remove_nodes_load_balancer
      request :remove_servers_server_group
      request :reset_ftp_password_account
      request :reset_secret_api_client
      request :shutdown_server
      request :snapshot_server
      request :start_server
      request :stop_server
      request :unmap_cloud_ip
      request :update_account
      request :update_api_client
      request :update_cloud_ip
      request :update_firewall_rule
      request :update_image
      request :update_load_balancer
      request :update_server
      request :update_server_group
      request :update_user

      module Shared
        # Returns an identifier for the default image for use
        #
        # Currently tries to find the latest version Ubuntu LTS (i686) widening
        # up to the latest, official version of Ubuntu available.
        #
        # Highly recommended that you actually select the image you want to run
        # on your servers yourself!
        #
        # @return [String, nil]
        def default_image
          return @default_image_id unless @default_image_id.nil?
          @default_image_id = Fog.credentials[:brightbox_default_image] || select_default_image
        end
      end

      class Mock
        include Shared

        def initialize(options)
          @brightbox_client_id = options[:brightbox_client_id] || Fog.credentials[:brightbox_client_id]
          @brightbox_secret = options[:brightbox_secret] || Fog.credentials[:brightbox_secret]
        end

        def request(options)
          raise "Not implemented"
        end

      private
        def select_default_image
          "img-mockd"
        end
      end

      class Real
        include Shared

        def initialize(options)
          # Currently authentication and api endpoints are the same but may change
          @auth_url             = options[:brightbox_auth_url] || Fog.credentials[:brightbox_auth_url] || API_URL
          @api_url              = options[:brightbox_api_url] || Fog.credentials[:brightbox_api_url] || API_URL
          @connection_options   = options[:connection_options] || {}
          @brightbox_client_id  = options[:brightbox_client_id] || Fog.credentials[:brightbox_client_id]
          @brightbox_secret     = options[:brightbox_secret] || Fog.credentials[:brightbox_secret]
          @persistent           = options[:persistent] || false
          @connection = Fog::Connection.new(@api_url, @persistent, @connection_options)
        end

        def request(method, url, expected_responses, options = nil)
          request_options = {
            :method   => method.to_s.upcase,
            :path     => url,
            :expects  => expected_responses
          }
          request_options[:body] = Fog::JSON.encode(options) unless options.nil?
          make_request(request_options)
        end

        def account
          Fog::Compute::Brightbox::Account.new(get_account)
        end

      private
        def get_oauth_token(options = {})
          auth_url = options[:brightbox_auth_url] || @auth_url

          connection = Fog::Connection.new(auth_url)
          @authentication_body = Fog::JSON.encode({'client_id' => @brightbox_client_id, 'grant_type' => 'none'})

          response = connection.request({
            :path => "/token",
            :expects  => 200,
            :headers  => {
              'Authorization' => "Basic " + Base64.encode64("#{@brightbox_client_id}:#{@brightbox_secret}").chomp,
              'Content-Type' => 'application/json'
            },
            :method   => 'POST',
            :body     => @authentication_body
          })
          @oauth_token = Fog::JSON.decode(response.body)["access_token"]
          return @oauth_token
        end

        def make_request(params)
          begin
            get_oauth_token if @oauth_token.nil?
            response = authenticated_request(params)
          rescue Excon::Errors::Unauthorized
            get_oauth_token
            response = authenticated_request(params)
          end
          unless response.body.empty?
            response = Fog::JSON.decode(response.body)
          end
        end

        def authenticated_request(options)
          headers = options[:headers] || {}
          headers.merge!("Authorization" => "OAuth #{@oauth_token}", "Content-Type" => "application/json")
          options[:headers] = headers
          @connection.request(options)
        end

        # Queries the API and tries to select the most suitable official Image
        # to use if the user chooses not to select their own.
        def select_default_image
          return @default_image_id unless @default_image_id.nil?

          all_images = Fog::Compute[:brightbox].list_images
          official_images = all_images.select {|img| img["official"] == true}
          ubuntu_lts_images = official_images.select {|img| img["name"] =~ /Ubuntu.*LTS/}
          ubuntu_lts_i686_images = ubuntu_lts_images.select {|img| img["arch"] == "i686"}

          if ubuntu_lts_i686_images.empty?
            # Accept other architectures
            if ubuntu_lts_images.empty?
              # Accept non-LTS versions of Ubuntu
              unsorted_images = official_images.select {|img| img["name"] =~ /Ubuntu/}
            else
              unsorted_images = ubuntu_lts_images
            end
          else
            unsorted_images = ubuntu_lts_i686_images
          end

          # Get the latest and use it's ID for the default image
          @default_image_id = unsorted_images.sort {|a,b| a["created_at"] <=> b["created_at"]}.first["id"]
        rescue
          nil
        end
      end

    end
  end
end
