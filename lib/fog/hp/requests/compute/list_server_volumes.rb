module Fog
  module Compute
    class HP
      class Real
        # List all volumes attached to a server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to list attached volumes for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'volumeAttachments'<~Array>:
        #     * <~Hash>
        #       *  'device':<~String>  - The name of the device
        #       *  'serverId':<~Integer>  - The server id to which thsi volume is attached
        #       *  'id':<~Integer>  - The volume id
        #       *  'volumeId':<~Integer>  - The volume id
        def list_server_volumes(server_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "servers/#{server_id}/os-volume_attachments"
          )
          response
        end
      end

      class Mock  # :nodoc:all
        def list_server_volumes(server_id)
          response = Excon::Response.new
          volumes = []
          if server = self.data[:servers][server_id]
            volumes = server['volumeAttachments']
            response.status = 200
            response.body = { 'volumeAttachments' => volumes }
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
