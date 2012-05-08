module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def create_load_balancer(name, protocol, port, virtual_ips, nodes, options = {})
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

          data['loadBalancer']['algorithm'] = options[:algorithm] if options.has_key? :algorithm

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => 'loadbalancers.json'
          )
        end
      end
    end
  end
end
