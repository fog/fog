module Fog
  module Compute
    class HPV2
      class Real
        # List all volumes attached to a server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to list attached volumes for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'volumeAttachments'<~Array>:
        #     * <~Hash>
        #       *  'device':<~String>  - The name of the device
        #       *  'serverId':<~String>  - UUId of the server to which this volume is attached to
        #       *  'id':<~String>  - UUId of the volume
        #       *  'volumeId':<~String>  - UUId of the volume
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
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
