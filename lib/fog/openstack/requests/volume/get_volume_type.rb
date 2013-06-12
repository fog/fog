module Fog
  module Volume
    class OpenStack

      class Real
        def get_volume_type(volume_type_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "types/#{volume_type_id}"
          )
        end
      end

      class Mock
        def get_volume_type(volume_type_id)
          response = Excon::Response.new
          if volume_type = list_volume_types.body['volume_types'].detect { |_| _['id'] == volume_type_id }
            response.status = 200
            response.body = { 'volume_type' => volume_type }
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end