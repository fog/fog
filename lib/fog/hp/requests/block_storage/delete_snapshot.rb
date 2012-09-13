module Fog
  module BlockStorage
    class HP
      class Real

        # Delete an existing block storage snapshot
        #
        # ==== Parameters
        # * snapshot_id<~Integer> - Id of the snapshot to delete
        #
        def delete_snapshot(snapshot_id)
          response = request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-snapshots/#{snapshot_id}"
          )
          response
        end

      end

      class Mock # :nodoc:all

        def delete_snapshot(snapshot_id)
          response = Excon::Response.new
          if self.data[:snapshots][snapshot_id]
            self.data[:snapshots].delete(snapshot_id)
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