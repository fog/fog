module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def get_load_balancer(load_balancer_id)
          request(
            :expects => 200,
            :path => "loadbalancers/#{load_balancer_id}.json",
            :method => 'GET'
          )
         end
      end

      class Mock
        def get_load_balancer(load_balancer_id)
          response = Excon::Response.new
          response.status = 200
          response.body =  {
            "loadBalancer"=> {
              "name"=>"load_balancer_#{load_balancer_id}",
              "id"=> load_balancer_id,
              "protocol"=>"HTTP",
              "port"=>80,
              "algorithm"=>"RANDOM",
              "status"=>"ACTIVE",
              "cluster"=>{"name"=>"my-cluster.rackspace.net"},
              "nodes"=>[{"address"=> MockData.ipv4_address, "id"=> Fog::Mock.random_numbers(6), "type"=>"PRIMARY", "port"=>80, "status"=>"ONLINE", "condition"=>"ENABLED"}],
              "timeout"=>30,
              "created"=>{"time"=>MockData.zulu_time},
              "virtualIps"=>[
                {"address"=> MockData.ipv4_address, "id"=>Fog::Mock.random_numbers(4), "type"=>"PUBLIC", "ipVersion"=>"IPV4"},
                {"address"=> MockData.ipv6_address, "id"=>Fog::Mock.random_numbers(4), "type"=>"PUBLIC", "ipVersion"=>"IPV6"}],
              "sourceAddresses"=>{"ipv6Public"=> MockData.ipv6_address, "ipv4Servicenet"=> MockData.ipv4_address, "ipv4Public"=> MockData.ipv4_address},
              "updated"=>{"time"=>"2013-09-04T06:29:09Z"},
              "halfClosed"=>false,
              "connectionLogging"=>{"enabled"=>false},
              "contentCaching"=>{"enabled"=>false},
              "httpsRedirect"=>false}}
            response
         end
      end
    end
  end
end
