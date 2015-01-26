module Fog
  module Rackspace
    class NetworkingV2
      class Real
        def update_subnet(subnet)
          data = {
            :subnet => {
              :name => subnet.name,
              :gateway_ip => subnet.gateway_ip
            }
          }

          request(
            :method  => 'PUT',
            :body    => Fog::JSON.encode(data),
            :path    => "subnets/#{subnet.id}",
            :expects => 200
          )
        end
      end
    end
  end
end
