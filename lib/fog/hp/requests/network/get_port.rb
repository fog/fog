module Fog
  module HP
    class Network
      class Real
        # Get details for an existing port by id
        #
        # ==== Parameters
        # * 'port_id'<~String>: - UUId for the port to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * port<~Array>:
        #       * 'id'<~String>: - UUId for the port
        #       * 'name'<~String>: - Name of the port
        #       * 'network_id'<~String>: - UUId of the network
        #       * 'tenant_id'<~String>: - TenantId that owns the port
        #       * 'status'<~String>: - Status of the port i.e. ACTIVE
        #       * 'admin_state_up'<~Boolean>: - true or false
        #       * 'binding:vif_type'<~String>: - "other"
        #       * 'device_owner'<~String>: - Device owner of the port i.e. "network:dhcp"
        #       * 'mac_address'<~String>: - MAC address of the port
        #       * 'fixed_ips'<~Array>:
        #         * 'subnet_id'<~String>: - UUId of the subnet
        #         * 'ip_address'<~String>: - IP address
        #       * 'security_groups'<~Array>: - Security Groups
        #       * 'device_id'<~String>: - Id of the device
        def get_port(port_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "ports/#{port_id}"
          )
        end
      end

      class Mock
        def get_port(port_id)
          response = Excon::Response.new
          if port = list_ports.body['ports'].find {|_| _['id'] == port_id}
            response.status = 200
            response.body = { 'port' => port }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
