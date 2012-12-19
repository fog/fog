module Fog
  module Network
    class OpenStack

      class Real
        def get_floatingip(floating_network_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "floatingips/#{floating_network_id}"
          )
        end
      end

      class Mock
        def get_floatingip(floating_network_id)
          response = Excon::Response.new
          if data = self.data[:floatingips][floating_network_id]
            response.status = 200
            response.body = {
              "floatingip" => {
                "id"                  => "00000000-0000-0000-0000-000000000000",
                "floating_network_id" => floating_network_id,
                "port_id"             => data["port_id"],
                "tenant_id"           => data["tenant_id"],
                "fixed_ip_address"    => data["fixed_ip_address"],
                "router_id"           => "00000000-0000-0000-0000-000000000000",
                "floating_ip_address" => data["floating_ip_address"],
              }
            }
            response
          else
            raise Fog::Network::OpenStack::NotFound
          end
        end
      end


    end
  end
end
