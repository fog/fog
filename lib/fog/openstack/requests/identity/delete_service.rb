module Fog
  module Identity
    class OpenStack
      class Real
        def delete_service(id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "OS-KSADM/services/#{id}"
          )
        end # def delete_service
      end # class Real

      class Mock
        def delete_service(attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            'OS-KSADM:service' => {
              'id' => '1',
              'description' => 'normal service',
              'type' => 'image',
              'name' => 'image'
            }
          }
          response
        end # def delete_service
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
