module Fog
  module HP
    class LB
      # Create a new load balancer
      #
      # ==== Parameters
      # * 'name'<~String> - Name of the load balancer
      # * 'nodes'<~ArrayOfHash> - Nodes for the load balancer
      #   * 'address'<~String> - Address for the node
      #   * 'port'<~String> - Port for the node
      # * options<~Hash>:
      #   * 'port'<~String> - Port for the load balancer, defaults to '80'
      #   * 'protocol'<~String> - Protocol for the load balancer, defaults to 'HTTP'
      #   * 'algorithm'<~String> - Algorithm for the load balancer, defaults to 'ROUND_ROBIN'
      #   * 'virtualIps'<~ArrayOfHash> - Virtual IPs for the load balancer
      #     * 'id'<~String> - UUId for the virtual IP
      #     * 'address'<~String> - Address for the virtual IP
      #     * 'type'<~String> - Type for the virtual IP
      #     * 'ipVersion'<~String> - IP Version for the virtual IP
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'id'<~String> - UUID of the load balancer
      #     * 'name'<~String> - Name of the load balancer
      #     * 'protocol'<~String> - Protocol for the load balancer
      #     * 'port'<~String> - Port for the load balancer
      #     * 'algorithm'<~String> - Algorithm for the load balancer
      #     * 'status'<~String> - Status for the load balancer
      #     * 'created'<~String> - created date time stamp
      #     * 'updated'<~String> - updated date time stamp
      #     * 'nodes'<~ArrayOfHash> - Nodes for the load balancer
      #       * 'address'<~String> - Address for the node
      #       * 'port'<~String> - Port for the node
      #     * 'virtualIps'<~ArrayOfHash> - Virtual IPs for the load balancer
      #       * 'id'<~String> - UUId for the virtual IP
      #       * 'address'<~String> - Address for the virtual IP
      #       * 'type'<~String> - Type for the virtual IP
      #       * 'ipVersion'<~String> - IP Version for the virtual IP
      class Real
        def create_load_balancer(name, nodes, options={})
          ### Inconsistent behavior. Should be passing in as a 'loadbalancer' => {'name', 'nodes'}
          data = {
            'name'  => name,
            'nodes' => nodes
          }
          l_options = ['port', 'protocol', 'algorithm']
          l_options.select{|o| options[o]}.each do |key|
            data[key] = options[key]
          end

          if options['virtualIps']
            data['virtualIps'] = []
            for vip in options['virtualIps']
              data['virtualIps'] << vip
            end
          end

          response = request(
            :body    => Fog::JSON.encode(data),
            :expects => 202,
            :method  => 'POST',
            :path    => 'loadbalancers'
          )
          response
        end
      end

      class Mock
        def create_load_balancer(name, nodes, options={})
          ### Call: {"name" => "my-shiny-lb1", "nodes" => [{"address" => "15.185.1.1", "port" => "80"}]}
          response = Excon::Response.new
          response.status = 202
          # add the id, and other attributes that are added by the system
          nodes.each do |n|
            n['id']         = Fog::HP::Mock.uuid.to_s
            n['condition']  = 'ENABLED'
            n['status']     = 'ONLINE'
          end
          data = {
              'id'        => Fog::HP::Mock.uuid.to_s,
              'name'      => name,
              'protocol'  => options['protocol'] || 'HTTP',
              'port'      => options['port'] || '80',
              'algorithm' => options['algorithm'] || 'ROUND_ROBIN',
              'status'    => 'ACTIVE',
              'created'   => '2012-01-01T13:32:20Z',
              'updated'   => '2012-01-01T13:32:20Z',
              'nodes'     => nodes
          }
          if (!options['virtualIps'].nil? && !options['virtualIps'].empty?)
            data['virtualIps'] = options['virtualIps']
          else
            data['virtualIps'] = [{
                             'ipVersion' => 'IPV4',
                             'type' => 'PUBLIC',
                             'id' => Fog::HP::Mock.uuid.to_s,
                             'address' => Fog::HP::Mock.ip_address
                          }]
          end

          self.data[:lbs][data['id']] = data
          response.body = data
          response
        end
      end
    end
  end
end
