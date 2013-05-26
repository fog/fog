module Fog
  module Volume
    class OpenStack

      class Real
        def delete_backup(backup_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "backups/#{backup_id}"
          )
        end
      end

      class Mock
        def delete_backup(backup_id)
          response = Excon::Response.new
          if list_backups.body['backups'].map { |r| r['id'] }.include? backup_id
            self.data[:backups].delete(backup_id)
            response.status = 204
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end