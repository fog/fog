module Fog
  module Volume 
    class OpenStack

      class Real
        def get_backup_details(backup_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "backups/#{backup_id}"
          )
        end
      end

      class Mock
        def get_backup_details(backup_id)
          response = Excon::Response.new
          if backup = self.data[:backups][backup_id]
            response.status = 200
            response.body = { 'backup' => backup }
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end