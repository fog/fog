module Fog
  module Identity
    class OpenStack
      class Real
        def list_services(limit = nil, marker = nil)
          params = Hash.new
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "OS-KSADM/services",
            :query   => params
          )
        end
      end # class Real

      class Mock
        def list_services
          Excon::Response.new(
            :body => {
              'OS-KSADM:services' => [
                {'id' => '1',
                 'description' => 'Compute Service',
                 'type' => 'compute',
                 'name' => 'nova'},
                {'id' => '2',
                 'description' => 'Identity Service',
                 'type' => 'identity',
                 'name' => 'keystone'},
                {'id' => '3',
                 'description' => 'Image Service',
                 'type' => 'image',
                 'name' => 'glance'}
              ]
            },
            :status => [200, 204][rand(1)]
          )
        end # def list_services
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
