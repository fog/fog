require 'fog/core'
require 'fog/xml'

module Fog
  module Google
    extend Fog::Provider

    service(:compute,    'Compute')
    service(:dns,        'DNS')
    service(:monitoring, 'Monitoring')
    service(:storage,    'Storage')
    service(:sql,        'SQL')

    class Mock
      def self.etag
        hex(32)
      end

      def self.hex(length)
        max = ('f' * length).to_i(16)
        rand(max).to_s(16)
      end
    end

    module Shared
      attr_reader :project, :api_version, :api_url

      ##
      # Initializes shared attributes
      #
      # @param [String] project Google Cloud Project
      # @param [String] api_version Google API version
      # @param [String] base_url Google API base url
      # @return [void]
      def shared_initialize(project, api_version, base_url)
        @project = project
        @api_version = api_version
        @api_url = base_url + api_version + '/projects/'
      end

      ##
      # Initializes the Google API Client
      #
      # @param [Hash] options Google API options
      # @option options [String] :google_client_email A @developer.gserviceaccount.com email address to use
      # @option options [String] :google_key_location The location of a pkcs12 key file
      # @option options [String] :google_key_string The content of the pkcs12 key file
      # @option options [String] :google_json_key_location The location of a JSON key file
      # @option options [String] :google_json_key_string The content of the JSON key file
      # @option options [String] :google_api_scope_url The access scope URLs
      # @option options [String] :app_name The app name to set in the user agent
      # @option options [String] :app_version The app version to set in the user agent
      # @option options [Google::APIClient] :google_client Existing Google API Client
      # @return [Google::APIClient] Google API Client
      # @raises [ArgumentError] If there is any missing argument
      def initialize_google_client(options)
        # NOTE: loaded here to avoid requiring this as a core Fog dependency
        begin
          require 'google/api_client'
        rescue LoadError => error
          Fog::Logger.warning('Please install the google-api-client gem before using this provider')
          raise error
        end

        # User can provide an existing Google API Client
        client = options[:google_client]
        return client unless client.nil?

        # Create a signing key
        signing_key = create_signing_key(options)

        # Validate required arguments
        unless options[:google_client_email]
          raise ArgumentError.new('Missing required arguments: google_client_email')
        end

        unless options[:google_api_scope_url]
          raise ArgumentError.new('Missing required arguments: google_api_scope_url')
        end

        # Create a new Google API Client
        self.new_pk12_google_client(
          options[:google_client_email],
          signing_key,
          options[:google_api_scope_url],
          options[:app_name],
          options[:app_version]
        )
      end

      ##
      # Creates a Google signing key
      #
      def create_signing_key(options)
        if options[:google_json_key_location] || options[:google_json_key_string]
          if options[:google_json_key_location]
            json_key_location = File.expand_path(options[:google_json_key_location])
            json_key = File.open(json_key_location, 'r') { |file| file.read }
          else
            json_key = options[:google_json_key_string]
          end

          json_key_hash = Fog::JSON.decode(json_key)
          unless json_key_hash.has_key?('client_email') || json_key_hash.has_key?('private_key')
            raise ArgumentError.new('Invalid Google JSON key')
          end

          options[:google_client_email] = json_key_hash['client_email']
          ::Google::APIClient::KeyUtils.load_from_pem(json_key_hash['private_key'], 'notasecret')
        elsif options[:google_key_location] || options[:google_key_string]
          if options[:google_key_location]
            google_key = File.expand_path(options[:google_key_location])
          else
            google_key = options[:google_key_string]
          end

          ::Google::APIClient::KeyUtils.load_from_pkcs12(google_key, 'notasecret')
        else
          raise ArgumentError.new('Missing required arguments: google_key_location, google_key_string, ' \
                                  'google_json_key_location or google_json_key_string')
        end
      end

      ##
      # Create a Google API Client with a user email and a pkcs12 key
      #
      # @param [String] google_client_email A @developer.gserviceaccount.com email address to use
      # @param [OpenSSL::PKey] signing_key The private key for signing
      # @param [String] google_api_scope_url Access scope URLs
      # @param [String] app_name The app name to set in the user agent
      # @param [String] app_version The app version to set in the user agent
      # @return [Google::APIClient] Google API Client
      def new_pk12_google_client(google_client_email, signing_key, google_api_scope_url, app_name = nil, app_version = nil)
        application_name = app_name.nil? ? 'fog' : "#{app_name}/#{app_version || '0.0.0'} fog"
        api_client_options = {
          :application_name => application_name,
          :application_version => Fog::VERSION,
        }
        client = ::Google::APIClient.new(api_client_options)

        client.authorization = Signet::OAuth2::Client.new(
          {
            :audience => 'https://accounts.google.com/o/oauth2/token',
            :auth_provider_x509_cert_url => 'https://www.googleapis.com/oauth2/v1/certs',
            :client_x509_cert_url => "https://www.googleapis.com/robot/v1/metadata/x509/#{google_client_email}",
            :issuer => google_client_email,
            :scope => google_api_scope_url,
            :signing_key => signing_key,
            :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
          }
        )
        client.authorization.fetch_access_token!

        client
      end

      ##
      # Executes a request and wraps it in a result object
      #
      # @param [Google::APIClient::Method] api_method The method object or the RPC name of the method being executed
      # @param [Hash] parameters The parameters to send to the method
      # @param [Hash] body_object The body object of the request
      # @return [Excon::Response] The result from the API
      def request(api_method, parameters, body_object = nil)
        client_parms = {
          :api_method => api_method,
          :parameters => parameters,
        }
        client_parms[:body_object] = body_object if body_object

        result = @client.execute(client_parms)

        build_excon_response(result.body.nil? || result.body.empty? ? nil : Fog::JSON.decode(result.body), result.status)
      end

      ##
      # Builds an Excon response
      #
      # @param [Hash] Response body
      # @param [Integer] Response status
      # @return [Excon::Response] Excon response
      def build_excon_response(body, status = 200)
        response = Excon::Response.new(:body => body, :status => status)
        if body && body.has_key?('error')
          msg = 'Google Cloud did not return an error message'

          if body['error'].kind_of?(Hash)
            response.status = body['error']['code']
            if body['error'].has_key?('errors')
              msg = body['error']['errors'].map{ |error| error['message'] }.join(', ')
            elsif body['error'].has_key?('message')
              msg = body['error']['message']
            end
          elsif body['error'].kind_of?(Array)
            msg = body['error'].map{ |error| error['code'] }.join(', ')
          end

          case response.status
            when 404
              raise Fog::Errors::NotFound.new(msg)
            else
              raise Fog::Errors::Error.new(msg)
          end
        end

        response
      end
    end
  end
end
