module Fog
  module Identity
    class OpenStack
      class Real
        def update_service(id, attributes)
          request(
            :expects => [200],
            :method  => 'PUT',
            :path    => "OS-KSADM/services/#{id}",
            :body    => Fog::JSON.encode({ 'OS-KSADM:service' => attributes })
          )
        end # def update_service
      end # class Real

      class Mock
        def update_service(id, attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          attributes = {'id' => '1'}.merge(attributes)
          response.body = {
            'OS-KSADM:service' => attributes
          }
          response
        end # def update_service
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
