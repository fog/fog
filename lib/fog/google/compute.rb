require 'fog/google'
require 'fog/compute'

module Fog
  module Compute
    class Google < Fog::Service

      requires :google_project
      requires :google_client_email
      requires :google_key_location

      request_path 'fog/google/requests/compute'
      request :list_servers
      request :list_disks
      request :list_firewalls
      request :list_images
      request :list_machine_types
      request :list_networks
      request :list_zones
      request :list_global_operations
      request :list_zone_operations

      request :get_server
      request :get_disk
      request :get_firewall
      request :get_image
      request :get_machine_type
      request :get_network
      request :get_zone

      request :delete_disk
      request :delete_firewall
      request :delete_image
      request :delete_network
      request :delete_operation
      request :delete_server

      request :insert_disk
      request :insert_firewall
      request :insert_image
      request :insert_network
      request :insert_server

      model_path 'fog/google/models/compute'
      model :server
      collection :servers

      model :image
      collection :images

      model :flavor
      collection :flavors

      class Mock
        include Collections

        def initialize(options)
          Fog::Mock::not_implemented
        end

      end

      class Real
        include Collections

        attr_reader :project

        def initialize(options)


          base_url = 'https://www.googleapis.com/compute/'
          api_version = 'v1beta14'
          api_scope_url = 'https://www.googleapis.com/auth/compute'

          @project = options[:google_project]
          google_client_email = options[:google_client_email]
          @api_url = base_url + api_version + '/projects/'
          #NOTE: loaded here to avoid requiring this as a core Fog dependency
          begin
            require 'google/api_client'
          rescue LoadError
            Fog::Logger.warning("Please install the google-api-client gem before using this provider.")
          end
          key = ::Google::APIClient::KeyUtils.load_from_pkcs12(File.expand_path(options[:google_key_location]), 'notasecret')

          @client = ::Google::APIClient.new({
            :application_name => "fog",
            :application_version => Fog::VERSION,
          })
          @client.authorization = Signet::OAuth2::Client.new({
            :audience => 'https://accounts.google.com/o/oauth2/token',
            :auth_provider_x509_cert_url => "https://www.googleapis.com/oauth2/v1/certs",
            :client_x509_cert_url => "https://www.googleapis.com/robot/v1/metadata/x509/#{google_client_email}",
            :issuer => google_client_email,
            :scope => api_scope_url,
            :signing_key => key,
            :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
          })
          @client.authorization.fetch_access_token!

          @compute = @client.discovered_api('compute', api_version)
          @default_network = 'default'
        end

        def build_result(api_method, parameters, body_object=nil)
          if body_object
            #p api_method, parameters
            result = @client.execute(
              :api_method => api_method,
              :parameters => parameters,
              :body_object => body_object
            )
          else
            result = @client.execute(
              :api_method => api_method,
              :parameters => parameters
            )
          end
        end

        def build_response(result)
          response = Excon::Response.new
          response.body = Fog::JSON.decode(result.body)
          if response.body["error"]
            response.status = response.body["error"]["code"]
          else
            response.status = 200
          end
          response
        end

      end

      RUNNING_STATE = 'RUNNING'

    end
  end
end
