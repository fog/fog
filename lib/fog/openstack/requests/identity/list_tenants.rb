module Fog
  module Identity
    class OpenStack
      class Real
        def list_tenants(limit = nil, marker = nil)
          params = Hash.new
          params['limit']  = limit  if limit
          params['marker'] = marker if marker

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "tenants",
            :query   => params
          )
        end
      end # class Real

      class Mock
        def list_tenants
          Excon::Response.new(
            :body => {
              'tenants_links' => [],
              'tenants' => [
                {'id' => '1',
                 'description' => 'Has access to everything',
                 'enabled' => true,
                 'name' => 'admin'},
                {'id' => '2',
                 'description' => 'Normal tenant',
                 'enabled' => true,
                 'name' => 'default'},
                {'id' => '3',
                 'description' => 'Disabled tenant',
                 'enabled' => false,
                 'name' => 'disabled'}
              ]
            },
            :status => [200, 204][rand(1)]
          )
        end # def list_tenants
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
