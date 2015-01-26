module Fog
  module Compute
    class HPV2
      class Real
        # Detach a block storage volume from an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of server to attach the volume to
        # * 'volume_id'<~String> - UUId of the volume to be attached to the server
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body: Empty
        def detach_volume(server_id, volume_id)
          response = request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "servers/#{server_id}/os-volume_attachments/#{volume_id}"
          )
          response
        end
      end

      class Mock  # :nodoc:all
        def detach_volume(server_id, volume_id)
          response = Excon::Response.new
          if server = self.data[:servers][server_id]
            if server['volumeAttachments'] && server['volumeAttachments'].select {|v| v['volumeId'] == volume_id}
              data = server['volumeAttachments'].reject {|v| v['volumeId'] == volume_id}
              self.data[:servers][server_id]['volumeAttachments'] = data
              response.status = 202
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
