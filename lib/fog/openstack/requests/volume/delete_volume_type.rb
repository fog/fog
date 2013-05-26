module Fog
  module Volume 
    class OpenStack

      class Real
        def delete_volume_type(volume_type_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "types/#{volume_type_id}"
          )
        end
      end

      class Mock
        def delete_volume_type(volume_type_id)
          response = Excon::Response.new
          if list_volume_types.body['volume_types'].map { |r| r['id'] }.include? volume_type_id
            self.data[:volume_types].delete(volume_type_id)
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