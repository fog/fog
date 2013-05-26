module Fog
  module Volume
    class OpenStack

      class Real
        def restore_backup(backup_id, volume_id)
          data = {
            'restore' => {
              'volume_id' => volume_id,
            }
          }
          
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "backups/#{backup_id}/restore"
          )
        end
      end

      class Mock
        def restore_backup(backup_id, volume_id)
          response = Excon::Response.new
          if list_backups.body['backups'].map { |r| r['id'] }.include? backup_id
            data = {
              'backup_id' => backup_id,
              'volume_id' => volume_id
            }
            response.body = { 'restore' => data }
            response.status = 202
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end