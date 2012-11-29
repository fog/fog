require 'fog/brightbox'
require 'fog/compute'
require 'fog/brightbox/oauth2'

module Fog
  module Compute
    class Brightbox < Fog::Service

      API_URL = "https://api.gb1.brightbox.com/"

      # Client credentials
      requires :brightbox_client_id, :brightbox_secret

      # API endpoint settings
      recognizes :brightbox_auth_url, :brightbox_api_url

      # User credentials (still requires client details)
      recognizes :brightbox_username, :brightbox_password, :brightbox_account

      # Cached tokens
      recognizes :brightbox_access_token, :brightbox_refresh_token

      # Automatic token management
      recognizes :brightbox_token_management

      # Excon connection settings
      recognizes :persistent

      model_path 'fog/brightbox/models/compute'
      collection  :accounts
      model       :account
      collection  :applications
      model       :application
      collection  :api_clients
      model       :api_client
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
      request :create_application
      request :create_cloud_ip
      request :create_firewall_policy
      request :create_firewall_rule
      request :create_image
      request :create_load_balancer
      request :create_server
      request :create_server_group
      request :destroy_api_client
      request :destroy_application
      request :destroy_cloud_ip
      request :destroy_firewall_policy
      request :destroy_firewall_rule
      request :destroy_image
      request :destroy_load_balancer
      request :destroy_server
      request :destroy_server_group
      request :get_account
      request :get_api_client
      request :get_application
      request :get_authenticated_user
      request :get_cloud_ip
      request :get_firewall_policy
      request :get_firewall_rule
      request :get_image
      request :get_interface
      request :get_load_balancer
      request :get_scoped_account
      request :get_server
      request :get_server_group
      request :get_server_type
      request :get_user
      request :get_zone
      request :list_accounts
      request :list_api_clients
      request :list_applications
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
      request :reset_ftp_password_scoped_account
      request :reset_secret_api_client
      request :reset_secret_application
      request :shutdown_server
      request :snapshot_server
      request :start_server
      request :stop_server
      request :unmap_cloud_ip
      request :update_account
      request :update_api_client
      request :update_application
      request :update_cloud_ip
      request :update_firewall_rule
      request :update_image
      request :update_load_balancer
      request :update_scoped_account
      request :update_server
      request :update_server_group
      request :update_user

      module Shared
        include Fog::Brightbox::OAuth2

        # Creates a new instance of the Brightbox Compute service
        #
        # @note If you open a connection using just a refresh token when it
        #   expires the service will no longer be able to authenticate.
        #
        # @param [Hash] options
        # @option options [String] :brightbox_api_url   Override the default (or configured) API endpoint
        # @option options [String] :brightbox_auth_url  Override the default (or configured) API authentication endpoint
        # @option options [String] :brightbox_client_id Client identifier to authenticate with (overrides configured)
        # @option options [String] :brightbox_secret    Client secret to authenticate with (overrides configured)
        # @option options [String] :brightbox_username  Email or user identifier for user based authentication
        # @option options [String] :brightbox_password  Password for user based authentication
        # @option options [String] :brightbox_account   Account identifier to scope this connection to
        # @option options [String] :connection_options  Settings to pass to underlying {Fog::Connection}
        # @option options [Boolean] :persistent         Sets a persistent HTTP {Fog::Connection}
        # @option options [String] :brightbox_access_token  Sets the OAuth access token to use rather than requesting a new token
        # @option options [String] :brightbox_refresh_token Sets the refresh token to use when requesting a newer access token
        # @option options [String] :brightbox_token_management Overide the existing behaviour to request access tokens if expired (default is `true`)
        #
        def initialize(options)
          # Currently authentication and api endpoints are the same but may change
          @auth_url            = options[:brightbox_auth_url]  || Fog.credentials[:brightbox_auth_url] || API_URL
          @auth_connection     = Fog::Connection.new(@auth_url)

          @api_url             = options[:brightbox_api_url]   || Fog.credentials[:brightbox_api_url]  || API_URL
          @connection_options  = options[:connection_options]  || {}
          @persistent          = options[:persistent]          || false
          @connection          = Fog::Connection.new(@api_url, @persistent, @connection_options)

          # Authentication options
          client_id            = options[:brightbox_client_id] || Fog.credentials[:brightbox_client_id]
          client_secret        = options[:brightbox_secret]    || Fog.credentials[:brightbox_secret]

          username             = options[:brightbox_username]  || Fog.credentials[:brightbox_username]
          password             = options[:brightbox_password]  || Fog.credentials[:brightbox_password]
          @configured_account  = options[:brightbox_account]   || Fog.credentials[:brightbox_account]
          # Request account can be changed at anytime and changes behaviour of future requests
          @scoped_account      = @configured_account

          credential_options   = {:username => username, :password => password}
          @credentials         = CredentialSet.new(client_id, client_secret, credential_options)

          # If existing tokens have been cached, allow continued use of them in the service
          @credentials.update_tokens(options[:brightbox_access_token], options[:brightbox_refresh_token])

          @token_management    = options.fetch(:brightbox_token_management, true)
        end

        # Sets the scoped account for future requests
        # @param [String] scoped_account Identifier of the account to scope request to
        def scoped_account=(scoped_account)
          @scoped_account = scoped_account
        end

        # This returns the account identifier that the request should be scoped by
        # based on the options passed to the request and current configuration
        #
        # @param [String] options_account Any identifier passed into the request
        #
        # @return [String, nil] The account identifier to scope the request to or nil
        def scoped_account(options_account = nil)
          [options_account, @scoped_account].compact.first
        end

        # Resets the scoped account back to intially configured one
        def scoped_account_reset
          @scoped_account = @configured_account
        end

        # Returns the scoped account being used for requests
        #
        # * For API clients this is the owning account
        # * For User applications this is the account specified by either +account_id+
        #   option on a connection or the +brightbox_account+ setting in your configuration
        #
        # @return [Fog::Compute::Brightbox::Account]
        #
        def account
          Fog::Compute::Brightbox::Account.new(get_scoped_account).tap do |acc|
            # Connection is more like the compute 'service'
            acc.connection = self
          end
        end

        # Returns true if authentication is being performed as a user
        # @return [Boolean]
        def authenticating_as_user?
          @credentials.user_details?
        end

        # Returns true if an access token is set
        # @return [Boolean]
        def access_token_available?
          !! @credentials.access_token
        end

        # Returns the current access token or nil
        # @return [String,nil]
        def access_token
          @credentials.access_token
        end

        # Returns the current refresh token or nil
        # @return [String,nil]
        def refresh_token
          @credentials.refresh_token
        end

        # Requests a new access token
        #
        # @return [String] New access token
        def get_access_token
          begin
            get_access_token!
          rescue Excon::Errors::Unauthorized, Excon::Errors::BadRequest
            @credentials.update_tokens(nil, nil)
          end
          @credentials.access_token
        end

        # Requests a new access token and raises if there is a problem
        #
        # @return [String] New access token
        # @raise [Excon::Errors::BadRequest] The credentials are expired or incorrect
        #
        def get_access_token!
          response = request_access_token(@auth_connection, @credentials)
          update_credentials_from_response(@credentials, response)
          @credentials.access_token
        end

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

      private

        # This makes a request of the API based on the configured setting for
        # token management.
        #
        # @param [Hash] options Excon compatible options
        # @see https://github.com/geemus/excon/blob/master/lib/excon/connection.rb
        #
        # @return [Hash] Data of response body
        #
        def make_request(options)
          if @token_management
            managed_token_request(options)
          else
            authenticated_request(options)
          end
        end

        # This request checks for access tokens and will ask for a new one if
        # it receives Unauthorized from the API before repeating the request
        #
        # @param [Hash] options Excon compatible options
        #
        # @return [Excon::Response]
        def managed_token_request(options)
          begin
            get_access_token unless access_token_available?
            response = authenticated_request(options)
          rescue Excon::Errors::Unauthorized
            get_access_token
            response = authenticated_request(options)
          end
        end

        # This request makes an authenticated request of the API using currently
        # setup credentials.
        #
        # @param [Hash] options Excon compatible options
        #
        # @return [Excon::Response]
        def authenticated_request(options)
          headers = options[:headers] || {}
          headers.merge!("Authorization" => "OAuth #{@credentials.access_token}", "Content-Type" => "application/json")
          options[:headers] = headers
          # TODO This is just a wrapper around a call to Excon::Connection#request
          #   so can be extracted from Compute by passing in the connection,
          #   credentials and options
          @connection.request(options)
        end
      end

      # The Mock Service allows you to run a fake instance of the Service
      # which makes no real connections.
      #
      # @todo Implement
      #
      class Mock
        include Shared

        def request(method, path, expected_responses, parameters = {})
          _request
        end

        def request_access_token(connection, credentials)
          _request
        end

      private

        def _request
          raise Fog::Errors::MockNotImplemented
        end

        def select_default_image
          "img-mockd"
        end
      end

      # The Real Service actually makes real connections to the Brightbox
      # service.
      #
      class Real
        include Shared

        # Makes an API request to the given path using passed options or those
        # set with the service setup
        #
        # @todo Standard Fog behaviour is to return the Excon::Response but
        #   this was unintentionally changed to be the Hash version of the
        #   data in the body. This loses access to some details and should
        #   be corrected in a backwards compatible manner
        #
        # @param [String] method HTTP method to use for the request
        # @param [String] path   The absolute path for the request
        # @param [Array<Fixnum>] expected_responses HTTP response codes that have been successful
        # @param [Hash]  parameters Keys and values for JSON
        # @option parameters [String] :account_id The scoping account if required
        #
        # @return [Hash]
        def request(method, path, expected_responses, parameters = {})
          request_options = {
            :method   => method.to_s.upcase,
            :path     => path,
            :expects  => expected_responses
          }

          # Select the account to scope for this request
          account = scoped_account(parameters.fetch(:account_id, nil))
          if account
            request_options[:query] = { :account_id => account }
          end

          request_options[:body] = Fog::JSON.encode(parameters) unless parameters.empty?

          response = make_request(request_options)

          # FIXME We should revert to returning the Excon::Request after a suitable
          # configuration option is in place to switch back to this incorrect behaviour
          unless response.body.empty?
            Fog::JSON.decode(response.body)
          else
            response
          end
        end

      private

        # Queries the API and tries to select the most suitable official Image
        # to use if the user chooses not to select their own.
        def select_default_image
          return @default_image_id unless @default_image_id.nil?

          all_images = list_images
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
