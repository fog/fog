module Fog
  module Rackspace
    class LoadBalancer
      class Real
        def create_load_balancer(name, protocol, port, virtual_ips, nodes)
          data = {
            'loadBalancer' => {
              'name' => name,
              'port' => port,
              'protocol' => protocol,
              'virtualIps' => virtual_ips,
              'nodes' => nodes
              #Is algorithm allowed on create?
            }
          }
          request(
            :body     => data.to_json,
            :expects  => 202,
            :method   => 'POST',
            :path     => 'loadbalancers.json'
          )
        end
      end
      class Mock
        def create_load_balancer(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
