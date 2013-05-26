module Fog
  module Volume
    class OpenStack

      class Real
        def get_volume_details(volume_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def get_volume_details(volume_id)
          response = Excon::Response.new
          if volume = self.data[:volumes][volume_id]
            response.status = 200
            response.body = { 'volume' => volume }
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end