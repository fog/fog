require "fog/brightbox/oauth2"

module Fog
  module Brightbox
    module Compute

      # The Shared module consists of code that was duplicated between the Real
      # and Mock implementations.
      #
      module Shared
        include Fog::Brightbox::OAuth2

        API_URL = "https://api.gb1.brightbox.com/"

        # Creates a new instance of the Brightbox Compute service
        #
        # @note If you create service using just a refresh token when it
        #   expires the service will no longer be able to authenticate.
        #
        # @param [Hash] options
        # @option options [String] :brightbox_api_url
        #   Override the default (or configured) API endpoint
        # @option options [String] :brightbox_auth_url
        #   Override the default (or configured) API authentication endpoint
        # @option options [String] :brightbox_client_id
        #   Client identifier to authenticate with (overrides configured)
        # @option options [String] :brightbox_secret
        #   Client secret to authenticate with (overrides configured)
        # @option options [String] :brightbox_username
        #   Email or user identifier for user based authentication
        # @option options [String] :brightbox_password
        #   Password for user based authentication
        # @option options [String] :brightbox_account
        #   Account identifier to scope this connection to
        # @option options [String] :connection_options
        #   Settings to pass to underlying {Fog::Core::Connection}
        # @option options [Boolean] :persistent
        #   Sets a persistent HTTP {Fog::Core::Connection}
        # @option options [String] :brightbox_access_token
        #   Sets the OAuth access token to use rather than requesting a new token
        # @option options [String] :brightbox_refresh_token
        #   Sets the refresh token to use when requesting a newer access token
        # @option options [String] (true) :brightbox_token_management
        # Overide the existing behaviour to request access tokens if expired
        #
        def initialize(options)
          # Currently authentication and api endpoints are the same but may change
          @auth_url            = options[:brightbox_auth_url]  || API_URL
          @auth_connection     = Fog::Core::Connection.new(@auth_url)

          @api_url             = options[:brightbox_api_url]   || API_URL
          @connection_options  = options[:connection_options]  || {}
          @persistent          = options[:persistent]          || false
          @connection          = Fog::Core::Connection.new(@api_url, @persistent, @connection_options)

          # Authentication options
          client_id            = options[:brightbox_client_id]
          client_secret        = options[:brightbox_secret]

          username             = options[:brightbox_username]
          password             = options[:brightbox_password]
          @configured_account  = options[:brightbox_account]
          # Request account can be changed at anytime and changes behaviour of future requests
          @scoped_account      = @configured_account

          credential_options   = { :username => username, :password => password }
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
        #   option on the service or the +brightbox_account+ setting in your configuration
        #
        # @return [Fog::Compute::Brightbox::Account]
        #
        def account
          account_data = get_scoped_account.merge(:service => self)
          Fog::Compute::Brightbox::Account.new(account_data)
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

        # Returns the current token expiry time in seconds or nil
        # @return [Number,nil]
        def expires_in
          @credentials.expires_in
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
        # Currently tries to find the latest version of Ubuntu (i686) from
        # Brightbox.
        #
        # Highly recommended that you actually select the image you want to run
        # on your servers yourself!
        #
        # @return [String] if image is found, returns the identifier
        # @return [NilClass] if no image is found or an error occurs
        #
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
          get_access_token unless access_token_available?
          authenticated_request(options)
        rescue Excon::Errors::Unauthorized
          get_access_token
          authenticated_request(options)
        end

        # This request makes an authenticated request of the API using currently
        # setup credentials.
        #
        # @param [Hash] options Excon compatible options
        #
        # @see https://github.com/geemus/excon/blob/master/lib/excon/connection.rb
        #
        # @return [Excon::Response]
        def authenticated_request(options)
          headers = options[:headers] || {}
          headers.merge!("Authorization" => "OAuth #{@credentials.access_token}", "Content-Type" => "application/json")
          options[:headers] = headers
          # TODO: This is just a wrapper around a call to Excon::Connection#request
          #   so can be extracted from Compute by passing in the connection,
          #   credentials and options
          @connection.request(options)
        end
      end
    end
  end
end
