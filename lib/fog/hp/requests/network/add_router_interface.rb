module Fog
  module HP
    class Network
      class Real
        # Add an internal router interface, thus attaching a subnet or a port to an existing router
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
        def add_router_interface(router_id, subnet_id=nil, port_id=nil, options = {})
          # Either a subnet or a port can be passed, not both
          if (subnet_id && port_id) || (subnet_id.nil? && port_id.nil?)
            raise ArgumentError.new('Either a subnet or a port can be passed, not both')
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
            :path     => "routers/#{router_id}/add_router_interface"
          )
        end
      end

      class Mock
        def add_router_interface(router_id, subnet_id=nil, port_id=nil, options = {})
          response = Excon::Response.new
          if list_routers.body['routers'].find {|_| _['id'] == router_id}
            # Either a subnet or a port can be passed, not both
            if (subnet_id && port_id) || (subnet_id.nil? && port_id.nil?)
              raise ArgumentError.new('Either a subnet or a port can be passed, not both')
            end

            if port_id.nil?
              # create a new port
              resp = create_port(self.data[:networks].keys[0], {:name => "New Port #{rand(10)}"})
              port_id = resp.body['port']['id']
            end

            data = {
              'subnet_id' => subnet_id || Fog::HP::Mock.uuid.to_s,
              'port_id'   => port_id
            }

            # so either way if I pass a subnet or a port,
            # it basically adds the router uuid to the port's device_id
            # and sets device_owner to network:router_interface
            self.data[:ports][port_id]['device_id'] = router_id
            self.data[:ports][port_id]['device_owner'] = 'network:router_interface'

            response.status = 200
            response.body = data
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
