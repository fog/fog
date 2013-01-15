module Fog
  module Rackspace
    class BlockStorage
      class Real
        def delete_volume(volume_id)
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def delete_volume(volume_id)
          volume = self.data[:volumes][volume_id]
          snapshots = self.data[:snapshots].values.select { |s| s["volume_id"] == volume_id }
          raise Fog::Rackspace::BlockStorage::BadRequest.new("Volume still has #{snapshots.count} dependent snapshots") if !snapshots.empty?
          unless volume.nil?
            unless volume["attachments"].empty?
              raise Fog::Rackspace::BlockStorage::BadRequest.new("Volume status must be available or error")
            end
            self.data[:volumes].delete(volume_id)
            response(:status => 202)
          else
            raise Fog::Rackspace::BlockStorage::NotFound
          end
        end
      end
    end
  end
end
