module Fog
  module Network
    class OpenStack

      class Real
        def add_router_interface(router_id, subnet_id, options = {})
          data = {
              'subnet_id' => subnet_id,
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200],
            :method   => 'PUT',
            :path     => "routers/#{router_id}/add_router_interface"
          )
        end
      end

      class Mock
        def add_router_interface(router_id, subnet_id, options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'status' => 'ACTIVE',
            'name' => '',
            'admin_state_up' => true,
            'network_id' => '5307648b-e836-4658-8f1a-ff7536870c64',
            'tenant_id' => '6b96ff0cb17a4b859e1e575d221683d3',
            'device_owner' => 'network:router_interface',
            'mac_address' => 'fa:16:3e:f7:d1:9c',
            'fixed_ips' => {
              'subnet_id' => 'a2f1f29d-571b-4533-907f-5803ab96ead1',
              'ip_address' => '10.1.1.1'
            },
            'id' => '3a44f4e5-1694-493a-a1fb-393881c673a4',
            'device_id' => '7177abc4-5ae9-4bb7-b0d4-89e94a4abf3b'
          }

          self.data[:routers][data['router_id']] = data
          response.body = { 'router' => data }
          response
        end
      end

    end
  end
end
