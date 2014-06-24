module Fog
  module Identity
    class OpenStack
      class Real
        def create_service(attributes)
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => "OS-KSADM/services",
            :body    => Fog::JSON.encode({ 'OS-KSADM:service' => attributes })
          )
        end # def create_service
      end # class Real

      class Mock
        def create_service(attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            'OS-KSADM:service' => {
              'id' => "df9a815161eba9b76cc748fd5c5af73e",
              'description' => attributes[:description] || 'normal service',
              'type' => attributes[:type] || 'default',
              'name' => attributes[:name] || 'default'
            }
          }
          response
        end # def create_service
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
