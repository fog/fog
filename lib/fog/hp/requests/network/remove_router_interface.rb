module Fog
  module HP
    class Network
      class Real
        # Remove an internal router interface, thus detaching a subnet or a port from an existing router
        #
        # ==== Parameters
        # * 'router_id'<~String>: - UUId for the router
        # * 'subnet_id'<~String>: - UUId for the subnet (Either a subnet or a port can be passed, not both)
        # * 'port_id'<~String>: - UUId for the port (Either a subnet or a port can be passed, not both)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'subnet_id'<~String>: - UUId for the subnet
        #     * 'port_id'<~String>: - UUId for the port
        def remove_router_interface(router_id, subnet_id=nil, port_id=nil, options = {})
          # Either a subnet or a port can be passed, not both
          if (subnet_id && port_id) || (subnet_id.nil? && port_id.nil?)
            raise ArgumentError.new('Bad router request: Cannot specify both subnet-id and port-id')
          end
          if subnet_id
            data = { 'subnet_id' => subnet_id }
          elsif port_id
            data = { 'port_id' => port_id }
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "routers/#{router_id}/remove_router_interface"
          )
        end
      end

      class Mock
        def remove_router_interface(router_id, subnet_id=nil, port_id=nil, options = {})
          response = Excon::Response.new
          if list_routers.body['routers'].find {|_| _['id'] == router_id}
            # Either a subnet or a port can be passed, not both
            if (subnet_id && port_id) || (subnet_id.nil? && port_id.nil?)
              raise ArgumentError.new('Either a subnet or a port can be passed, not both')
            end

            # delete the port
            if port_id
              delete_port(port_id)
            elsif subnet_id
              ports = self.data[:ports].select {|p| self.data[:ports]["#{p}"]['device_id'] == router_id }
                                                 #&& self.data[:ports]["#{p}"]['network_id'] == self.data[:subnets][subnet_id]['network_id']}
              ports.each do |key, _|
                delete_port(key)
              end
            end
            response.status = 200
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
