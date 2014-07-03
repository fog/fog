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
            }
          }

          data['loadBalancer']['nodes'] = nodes if nodes && !nodes.empty?
          data['loadBalancer']['algorithm'] = options[:algorithm] if options.key? :algorithm
          data['loadBalancer']['timeout'] = options[:timeout] if options.key? :timeout

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => 'loadbalancers.json'
          )
        end
      end

      class Mock
        def create_load_balancer(name, protocol, port, virtual_ips, nodes, options = {})
          data = {"loadBalancer"=>{"name"=>name, "id"=>Fog::Mock.random_numbers(6), "protocol"=>protocol, "port"=>port, "algorithm"=>"RANDOM", "status"=>"BUILD",
                                           "cluster"=>{"name"=>"my-cluster.rackspace.net"}, "timeout"=>30, "created"=>{"time"=> MockData.zulu_time},
                                           "updated"=>{"time"=>MockData.zulu_time }, "halfClosed"=>false, "connectionLogging"=>{"enabled"=>false}, "contentCaching"=>{"enabled"=>false}}}
                  data["virtual_ips"] = virtual_ips.map {|n| {"virtualIps"=>[{"address"=> MockData.ipv4_address, "id"=>Fog::Mock.random_numbers(6), "type"=> n.type, "ipVersion"=>"IPV4"}, {"address"=> MockData.ipv6_address, "id"=> Fog::Mock.random_numbers(4), "type"=>"PUBLIC", "ipVersion"=>"IPV6"}], "sourceAddresses"=>{"ipv6Public"=> MockData.ipv6_address, "ipv4Servicenet"=>MockData.ipv4_address, "ipv4Public"=>MockData.ipv4_address}}
                  data["nodes"] = nodes.map {|n| {"address"=>n.address, "id"=>Fog::Mock.random_numbers(6), "type"=>"PRIMARY", "port"=>n.port, "status"=>"ONLINE", "condition"=>"ENABLED", "weight"=>1}}}

          Excon::Response.new(:body => data, :status => 202)
        end
      end
    end
  end
end
