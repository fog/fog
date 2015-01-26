module Fog
  module HP
    class BlockStorageV2
      class Real
        # Delete an existing block storage snapshot
        #
        # ==== Parameters
        # * 'snapshot_id'<~String> - UUId of the snapshot to delete
        #
        def delete_snapshot(snapshot_id)
          response = request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "snapshots/#{snapshot_id}"
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
            raise Fog::HP::BlockStorageV2::NotFound
          end
          response
        end
      end
    end
  end
end
