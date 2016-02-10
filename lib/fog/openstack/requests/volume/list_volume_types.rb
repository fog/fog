module Fog
  module Volume
    class OpenStack
      module Real
        def list_volume_types(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'types',
            :query   => options
          )
        end
      end

      module Mock
        def list_volume_types(options = {})
          response = Excon::Response.new
          response.status = 200
          self.data[:volume_types] ||= [
            {
              "id" => "1",
              "name" => "type 1",
              "extra_specs" => {
                "volume_backend_name" => "type 1 backend name"
              }
            },
            {
              "id" => "2",
              "name" => "type 2",
              "extra_specs" => {
                "volume_backend_name" => "type 2 backend name"
              }
            }
          ]
          response.body = { 'volume_types' => self.data[:volume_types] }
          response
        end
      end
    end
  end
end
