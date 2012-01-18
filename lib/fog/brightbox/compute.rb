require File.expand_path(File.join(File.dirname(__FILE__), '..', 'brightbox'))
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
      request :resize_server
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

      class Mock

        def initialize(options)
          @brightbox_client_id = options[:brightbox_client_id] || Fog.credentials[:brightbox_client_id]
          @brightbox_secret = options[:brightbox_secret] || Fog.credentials[:brightbox_secret]
        end

        def request(options)
          raise "Not implemented"
        end
      end

      class Real

        def initialize(options)
          require 'multi_json'
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
          request_options[:body] = MultiJson.encode(options) unless options.nil?
          make_request(request_options)
        end

        def account
          Fog::Compute::Brightbox::Account.new(get_account)
        end

      private
        def get_oauth_token(options = {})
          auth_url = options[:brightbox_auth_url] || @auth_url

          connection = Fog::Connection.new(auth_url)
          @authentication_body = MultiJson.encode({'client_id' => @brightbox_client_id, 'grant_type' => 'none'})

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
          @oauth_token = MultiJson.decode(response.body)["access_token"]
          return @oauth_token
        end

        def make_request(params)
          begin
            get_oauth_token if @oauth_token.nil?
            response = authenticated_request(params)
          rescue Excon::Errors::Unauthorized => e
            get_oauth_token
            response = authenticated_request(params)
          end
          unless response.body.empty?
            response = MultiJson.decode(response.body)
          end
        end

        def authenticated_request(options)
          headers = options[:headers] || {}
          headers.merge!("Authorization" => "OAuth #{@oauth_token}", "Content-Type" => "application/json")
          options[:headers] = headers
          @connection.request(options)
        end
      end
    end
  end
end
