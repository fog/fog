module Fog
  module Rackspace
    class LoadBalancers
      class Real

        # Issue an asynchronous request to create a new Load Balancer.
        #
        # @param name [String] human-friendly identifier for the balancer that will be shown in
        #   the web UI.
        # @param protocol [String] well-known protocol describing the traffic to be load balanced.
        # @param port [Integer] port for the balancer to listen on and balance to.
        # @param virtual_ips [Array<Hash>] description of the kind of IP address to bind to, or id
        #   of the existing virtual IP from another balancer. Examples: `{ 'type' => 'PUBLIC' }`,
        #   `{ 'type' => 'PRIVATE' }`, `{ 'id' => 1234 }`
        # @param nodes [Array<Hash>] collection of
        # @option options [String] :algorithm balancing algorithm for the balancer to use.
        #   See http://docs.rackspace.com/loadbalancers/api/v1.0/clb-devguide/content/Algorithms-d1e4367.html
        # @option options [String] :timeout amount of time the load balancer will wait for a response
        #   from a back-end node before terminating the connection. Defaults to 30 seconds, may be
        #   increased to a maximum of 120 seconds.
        #
        def create_load_balancer(name, protocol, port = nil, virtual_ips = [{'type' => 'PUBLIC'}], nodes = nil, options = {})
          lb_data = {
            'name' => name,
            'protocol' => protocol,
            'virtualIps' => virtual_ips
          }

          lb_data['nodes'] = nodes if nodes && !nodes.empty?
          lb_data['port'] = port if port
          lb_data['algorithm'] = options[:algorithm] if options.key? :algorithm
          lb_data['timeout'] = options[:timeout] if options.key? :timeout
          lb_data['httpsRedirect'] = options[:https_redirect] if options.key? :https_redirect

          data = { 'loadBalancer' => lb_data }

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
          data = {
            "loadBalancer" => {
              "name" => name,
              "id" => Fog::Mock.random_numbers(6),
              "protocol" => protocol,
              "port" => port,
              "algorithm" => "RANDOM",
              "status" => "BUILD",
              "cluster" => { "name" => "my-cluster.rackspace.net" },
              "timeout" => 30,
              "created" => {"time" => MockData.zulu_time },
              "updated" => {"time" => MockData.zulu_time },
              "halfClosed" => false,
              "connectionLogging" => { "enabled" => false },
              "contentCaching" => { "enabled" => false },
              "httpsRedirect" => false
            }
          }

          data["virtual_ips"] = virtual_ips.map do |n|
            {
              "virtualIps" => [
                {
                  "address" => MockData.ipv4_address,
                  "id" => Fog::Mock.random_numbers(6),
                  "type" => n.type,
                  "ipVersion" => "IPV4"
                },
                {
                  "address" => MockData.ipv6_address,
                  "id" => Fog::Mock.random_numbers(4),
                  "type" => "PUBLIC",
                  "ipVersion" => "IPV6"
                }
              ],
              "sourceAddresses" => {
                "ipv6Public" => MockData.ipv6_address,
                "ipv4Servicenet" => MockData.ipv4_address,
                "ipv4Public" => MockData.ipv4_address
              }
            }
          end

          data["nodes"] = nodes.map do |n|
            {
              "address" => n.address,
              "id" => Fog::Mock.random_numbers(6),
              "type" => "PRIMARY",
              "port" => n.port,
              "status" => "ONLINE",
              "condition" => "ENABLED",
              "weight" => 1
            }
          end

          Excon::Response.new(:body => data, :status => 202)
        end
      end
    end
  end
end
