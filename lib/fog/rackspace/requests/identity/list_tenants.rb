module Fog
  module Rackspace
    class Identity
      class Real
        def list_tenants()
          response = request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'tenants'
          )

          unless response.body['tenants'].is_a?(Array)
            response.body['tenants'] = [response.body['tenant']]
            response.body.delete('tenant')
          end

          response
        end
      end
    end
  end
end
