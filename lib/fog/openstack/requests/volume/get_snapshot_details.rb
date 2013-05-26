module Fog
  module Volume 
    class OpenStack

      class Real
        def get_snapshot_details(snapshot_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock
        def get_snapshot_details(snapshot_id)
          response = Excon::Response.new
          if snapshot = self.data[:snapshots][snapshot_id]
            response.status = 200
            response.body = { 'snapshot' => snapshot }
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end