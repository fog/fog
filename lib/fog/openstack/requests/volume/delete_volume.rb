module Fog
  module Volume 
    class OpenStack

      class Real
        def delete_volume(volume_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def delete_volume(volume_id)
          response = Excon::Response.new
          if list_volumes.body['volumes'].map { |r| r['id'] }.include? volume_id
            self.data[:volumes].delete(volume_id)
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