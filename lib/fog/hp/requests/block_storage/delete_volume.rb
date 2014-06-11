module Fog
  module HP
    class BlockStorage
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
          if self.data[:volumes][volume_id]
            self.data[:volumes].delete(volume_id)
            response.status = 202
          else
            raise Fog::HP::BlockStorage::NotFound
          end
          response
        end
      end
    end
  end
end
