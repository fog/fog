module Fog
  module Identity
    class OpenStack
      class Real
        def get_service_by_id(service_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "OS-KSADM/services/#{service_id}"
          )
        end
      end

      class Mock
        def get_service_by_id(service_id)
          response = Excon::Response.new
          response.status = 200

          existing_service = self.data[:services].find do |u|
              u[0] == service_id || u[1]['name'] == 'mock'
            end
          existing_service = existing_service[1] if existing_service

          response.body = {
            'service' => existing_service || create_service('mock', 'mock', 'mock description').body['OS-KSADM:service']
          }
          response
        end
      end
    end
  end
end
