module Fog
  module Volume 
    class OpenStack

      class Real
        def set_volume_type_extra_spec(volume_type_id, extra_spec_key, extra_spec_value)
          data = {
            'extra_specs' => {
                extra_spec_key => extra_spec_value,
            }
          }
          
          request(
            :body    => MultiJson.encode(data),
            :expects => [200, 202],
            :method  => 'POST',
            :path    => "types/#{volume_type_id}/extra_specs"
          )
        end
      end

      class Mock
        def set_volume_type_extra_spec(volume_type_id, extra_spec_key, extra_spec_value)
          response = Excon::Response.new
          if volume_type = list_volume_types.body['volume_types'].detect { |_| _['id'] == volume_type_id }
            volume_type['extra_specs'][extra_spec_key] = extra_spec_value
            self.data[:volume_types][volume_type_id] = volume_type
            response.body = { 'extra_specs' => { extra_spec_key => extra_spec_value } }
            response.status = 202
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end