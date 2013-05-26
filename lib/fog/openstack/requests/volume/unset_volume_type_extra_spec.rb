module Fog
  module Volume 
    class OpenStack

      class Real
        def unset_volume_type_extra_spec(volume_type_id, extra_spec_key)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "types/#{volume_type_id}/extra_specs/#{extra_spec_key}"
          )
        end
      end

      class Mock
        def unset_volume_type_extra_spec(volume_type_id, extra_spec_key)
          response = Excon::Response.new
          if volume_type = list_volume_types.body['volume_types'].detect { |_| _['id'] == volume_type_id }
            volume_type['extra_specs'].delete(extra_spec_key)
            self.data[:volume_types][volume_type_id] = volume_type
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