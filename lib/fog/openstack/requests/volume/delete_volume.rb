module Fog
  module Volume
    class OpenStack
      class Real
        def delete_volume(volume_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def delete_volume(volume_id)
          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
