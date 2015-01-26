module Fog
  module HP
    class BlockStorageV2
      class Real
        # Delete an existing block storage volume backup
        #
        # ==== Parameters
        # * 'backup_id'<~String> - UUId of the volume backup to delete
        #
        def delete_volume_backup(backup_id)
          response = request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "backups/#{backup_id}"
          )
          response
        end
      end

      class Mock # :nodoc:all
        def delete_volume_backup(backup_id)
          response = Excon::Response.new
          if self.data[:volume_backups][backup_id]
            self.data[:volume_backups].delete(backup_id)
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
