module Fog
  module Compute
    class HPV2
      class Real
        # Get a block storage volume attachments for an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to get attached volumes for
        # * 'volume_id'<~String> - UUId of the volume attached to the server
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body: Empty
        def get_server_volume_details(server_id, volume_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "servers/#{server_id}/os-volume_attachments/#{volume_id}"
          )
          response
        end
      end

      class Mock  # :nodoc:all
        def get_server_volume_details(server_id, volume_id)
          response = Excon::Response.new
          if server = self.data[:servers][server_id]
            if server['volumeAttachments'] && server['volumeAttachments'].select {|v| v['volumeId'] == volume_id}
              data = server['volumeAttachments'].select {|v| v['volumeId'] == volume_id}
              response.body = { 'volumeAttachment' => data[0] }
              response.status = 200
            else
              raise Fog::Compute::HPV2::NotFound
            end
          else
            raise Fog::Compute::HPV2::NotFound
          end
          response
        end
      end
    end
  end
end
