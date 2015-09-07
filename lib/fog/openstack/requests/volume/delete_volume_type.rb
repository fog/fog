module Fog
  module Volume
    class OpenStack
      class Real
        def delete_volume_type(volume_type_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "types/#{volume_type_id}"
          )
        end
      end

      class Mock
        def delete_volume_type(volume_type_id)
          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
