module Fog
  module BlockStorage
    class HP
      class Real

        # Delete an existing block storage volume
        #
        # ==== Parameters
        # * volume_id<~Integer> - Id of the volume to delete
        #
        def delete_volume(volume_id)
          response = request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-volumes/#{volume_id}"
          )
          response
        end

      end

      class Mock # :nodoc:all

        def delete_volume(volume_id)
          response = Excon::Response.new
          if volume = self.data[:volumes][volume_id]
            response.status = 202
          else
            raise Fog::BlockStorage::HP::NotFound
          end
          response
        end
      end

    end
  end
end