require 'fog/google'
require 'fog/compute'
require 'fog/google/oauth/oauth_util'
require 'google/api_client'

module Fog
  module Compute
    class Google < Fog::Service

      requires :google_project

      request_path 'fog/google/requests/compute'
      request :list_servers
      request :list_disks
      request :list_firewalls
      request :list_images
      request :list_kernels
      request :list_machine_types
      request :list_networks
      request :list_operations
      request :list_zones

      request :get_server
      request :get_disk
      request :get_firewall
      request :get_image
      request :get_kernel
      request :get_machine_type
      request :get_network
      request :get_operation
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

        def initialize(options)
          base_url = 'https://www.googleapis.com/compute/'
          api_version = 'v1beta13'
          api_scope_url = 'https://www.googleapis.com/auth/compute'

          @project = options[:google_project]
          @api_url = base_url + api_version + '/projects/'
          @client = ::Google::APIClient.new
          @compute = @client.discovered_api('compute', api_version)
          @default_network = 'default'

          auth_util = CommandLineOAuthHelper.new(api_scope_url)
          @client.authorization = auth_util.authorize()
        end

        def build_result(api_method, parameters, body_object=nil)
          if body_object
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
