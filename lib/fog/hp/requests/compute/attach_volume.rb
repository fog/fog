module Fog
  module Compute
    class HP
      class Real
        # Attach a block storage volume to an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to attach the volume to
        # * volume_id<~Integer> - Id of the volume to be attached to the server
        # * device<~String> - Device name that is the mount point that the volume will be attached to. e.g. /dev/sdf
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'volumeAttachment'<~Hash>:
        #     * <~Hash>
        #       *  'volumeId':<~Integer>  - The volume id
        #       *  'device':<~String>  - The name of the device
        def attach_volume(server_id, volume_id, device)
          data = { 'volumeAttachment' =>
                   { 'volumeId' => volume_id,
                     'device'   => device
                   }
                 }
          response = request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => "servers/#{server_id}/os-volume_attachments"
          )
          response
        end
      end

      class Mock  # :nodoc:all
        def attach_volume(server_id, volume_id, device)
          response = Excon::Response.new
          if server = self.data[:servers][server_id]
            # mock the case when the volume is already attached to the server
            if server['volumeAttachments'] && server['volumeAttachments'].select {|v| v['id'] == volume_id}
              response.status = 400
              response.body = '{"badRequest": {"message": "Volume status must be available", "code": 400}}'
              raise(Excon::Errors.status_error({:expects => 200}, response))
            else
              resp_data = { "volumeAttachment" =>
                            {
                              "volumeId" => volume_id,
                              "id"       => volume_id
                            }
                          }
              response.body = resp_data
              response.status = 200

              data = {
                        "device"   => device,
                        "serverId" => server_id,
                        "id"       => volume_id,
                        "volumeId" => volume_id,
                     }
              if server['volumeAttachments']
                server['volumeAttachments'] << data
              else
                server['volumeAttachments'] = [data]
              end
            end
          else
            raise Fog::Compute::HP::NotFound
          end
          response
        end
      end
    end
  end
end
