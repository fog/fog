module Fog
  module HP
    class BlockStorageV2
      class Real
        # Restore an existing block storage volume backup to an existing or new volume
        #
        # If a volume is specified, that volume will be overwritten with the backup data from the backup.
        # If no volume is specified, a new volume will be created and used for the restore operation.
        #
        # ==== Parameters
        # * 'backup_id'<~String> - UUId of the volume backup to delete
        # * options<~Hash>:
        #   * 'volume_id'<~String> - UUId of the volume that will be overwritten by the backup data
        #
        def restore_volume_backup(backup_id, options={})
          data = {
            'restore' => {
              'backup_id' => backup_id
            }
          }

          l_options = ['volume_id']
          l_options.select{|o| options[o]}.each do |key|
            data['restore'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => "backups/#{backup_id}/restore"
          )
        end
      end

      class Mock # :nodoc:all
        def restore_volume_backup(backup_id, options={})
          volume_id = options['volume_id']

          response = Excon::Response.new
          if backup_volume = self.data[:volume_backups][backup_id]
            # get the volume from the backup that will be used to restore
            volume_to_restore = self.data[:volumes][backup_volume['volume_id']]
            if volume_id
              # overwrite the volume specified by the backup
              if self.data[:volumes][volume_id]
                data = copy_volume_data(volume_id, volume_to_restore)
                resp_volume_id = volume_id
              else
                raise Fog::HP::BlockStorageV2::NotFound.new("Invalid volume: '#{volume_id}' specified")
              end
            else
              # create a new volume and restore the backup
              new_vol = create_volume('display_name' => 'restore_backup', 'size' => 1).body
              new_vol_id = new_vol['volume']['id']
              data = copy_volume_data(new_vol_id, volume_to_restore)
              resp_volume_id = new_vol_id
            end
            # update the existing volume or create a new volume
            self.data[:volumes][resp_volume_id] = data
            resp_data = {
              'backup_id' => backup_id,
              'volume_id' => resp_volume_id
            }
            response.status = 202
            response.body = { 'restore' => resp_data }
          else
            raise Fog::HP::BlockStorageV2::NotFound
          end
          response
        end

        def copy_volume_data(volume_id, backup_volume)
          data = {
              'id'                  => volume_id,
              'status'              => 'available',
              'display_name'        => backup_volume['display_name'],
              'attachments'         => backup_volume['attachments'],
              'availability_zone'   => backup_volume['availability_zone'],
              'bootable'            => backup_volume['bootable'],
              'created_at'          => Time.now.to_s,
              'display_description' => backup_volume['display_description'],
              'volume_type'         => backup_volume['volume_type'],
              'snapshot_id'         => backup_volume['snapshot_id'],
              'source_volid'        => backup_volume['source_volid'],
              'metadata'            => backup_volume['metadata'],
              'size'                => backup_volume['size']
          }
        end
      end
    end
  end
end
