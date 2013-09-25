require 'fog/core/collection'
require 'fog/brightbox/models/compute/server'

module Fog
  module Compute
    class Brightbox

      class Servers < Fog::Collection

        model Fog::Compute::Brightbox::Server

        def all
          data = service.list_servers
          load(data)
        end

        # Creates a server and maps an Cloud IP
        #
        # By default the public SSH key you have registered with
        # Brightbox is already made available in an AWS compatible
        # metdata service.
        #
        # @todo Support uploading of arbitary SSH keys
        #
        # @param [Hash] options
        # @option options [String] name      Name for the server
        # @option options [String] flavor_id Identifier for virtual hardware type to request
        # @option options [String] image_id  Identifier for image to use when creating
        # @option options [String] zone_id   Identifer for preferred zone to locate server in
        # @option options [Array<String>] server_groups List of group identifiers for the server to join
        #
        # @return Fog::Compute::Brightbox::Server
        #
        def bootstrap(options = {})
          server = create(options)

          # Ensure server is now available
          server.wait_for { ready? }

          # To get a public IP address we need to map a cloud IP address
          cip = service.cloud_ips.allocate
          cip.map(server)
          cip.wait_for { mapped? }

          # Reload so the public IP is now available
          server.reload
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_server(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
