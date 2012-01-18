module Fog
  module Rackspace
    class LoadBalancers
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
            :body     => MultiJson.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => 'loadbalancers.json'
          )
        end
      end
    end
  end
end
