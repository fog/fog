module Fog
  module Identity
    class OpenStack
      class Real
        def delete_endpoint(id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "endpoints/#{id}"
          )
        end # def delete_endpoint
      end # class Real

      class Mock
        def delete_endpoint(attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            'endpoint' => {
              'id' => '1',
              'region' => 'RegionOne',
              'publicurl' => 'http://127.0.0.1/v2.0',
              'internalurl' => 'http://127.0.0.1/v2.0',
              'adminurl' => 'http://127.0.0.1/v2.0',
              'service_id' => "893e99a2bdc44bb6a870f7afabfbf322"
            }
          }
          response
        end # def delete_endpoint
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
