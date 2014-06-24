module Fog
  module Identity
    class OpenStack
      class Real
        def update_endpoint(id, attributes)
          request(
            :expects => [200],
            :method  => 'PUT',
            :path    => "endpoints/#{id}",
            :body    => Fog::JSON.encode({ 'endpoint' => attributes })
          )
        end # def update_endpoint
      end # class Real

      class Mock
        def update_endpoint(id, attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          attributes = {'id' => '1'}.merge(attributes)
          response.body = {
            'endpoint' => attributes
          }
          response
        end # def update_endpoint
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
