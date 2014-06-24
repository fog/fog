module Fog
  module Identity
    class OpenStack
      class Real
        def list_endpoints
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "endpoints"
          )
        end
      end # class Real

      class Mock
        def list_endpoints
          Excon::Response.new(
            :body => {
              'endpoints' => [
                {'id' => '1',
                 'region' => 'RegionOne',
                 'publicurl' => 'http://127.0.0.1/v2.0',
                 'internalurl' => 'http://127.0.0.1/v2.0',
                 'adminurl' => 'http://127.0.0.1/v2.0',
                 'service_id' => '1'},
                {'id' => '2',
                 'region' => 'RegionOne',
                 'publicurl' => 'http://127.0.0.1/v2.0',
                 'internalurl' => 'http://127.0.0.1/v2.0',
                 'adminurl' => 'http://127.0.0.1/v2.0',
                 'service_id' => '2'},
                {'id' => '3',
                 'region' => 'RegionOne',
                 'publicurl' => 'http://127.0.0.1/v2.0',
                 'internalurl' => 'http://127.0.0.1/v2.0',
                 'adminurl' => 'http://127.0.0.1/v2.0',
                 'service_id' => '3'},
              ]
            },
            :status => [200, 204][rand(1)]
          )
        end # def list_endpoints
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
