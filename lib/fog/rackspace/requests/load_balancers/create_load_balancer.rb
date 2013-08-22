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
            }
          }

          data['loadBalancer']['algorithm'] = options[:algorithm] if options.has_key? :algorithm
          data['loadBalancer']['timeout'] = options[:timeout] if options.has_key? :timeout

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
          data = {"loadBalancer"=>{"name"=>name, "id"=>uniq_id, "protocol"=>protocol, "port"=>port, "algorithm"=>"RANDOM", "status"=>"BUILD",
                                   "cluster"=>{"name"=>"ztm-n13.dfw1.lbaas.rackspace.net"}, "timeout"=>30, "created"=>{"time"=>"2013-08-20T20:52:44Z"},
                                   "updated"=>{"time"=>"2013-08-20T20:52:44Z"}, "halfClosed"=>false, "connectionLogging"=>{"enabled"=>false}, "contentCaching"=>{"enabled"=>false}}}
          data["virtual_ips"] = virtual_ips.collect {|n| {"virtualIps"=>[{"address"=>"192.237.192.152", "id"=>uniq_id, "type"=>n[:type], "ipVersion"=>"IPV4"}, {"address"=>"2001:4800:7901:0000:ba81:a6a5:0000:0002", "id"=>9153169, "type"=>"PUBLIC", "ipVersion"=>"IPV6"}], "sourceAddresses"=>{"ipv6Public"=>"2001:4800:7901::13/64", "ipv4Servicenet"=>"10.189.254.5", "ipv4Public"=>"166.78.44.5"}}
          data["nodes"] = nodes.collect {|n| {"address"=>n[:address], "id"=>uniq_id, "type"=>"PRIMARY", "port"=>n[:port], "status"=>"ONLINE", "condition"=>"ENABLED", "weight"=>1}}
          data = Excon::Response.new(:body => data, :status => 202)
          }
        end
      end
    end
  end
end
