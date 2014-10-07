module Fog
  module HP
    class Network
      class Real
        # List existing ports
        #
        # ==== Parameters
        # * options<~Hash>:
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * ports<~Array>:
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
        def list_ports(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'ports',
            :query   => options
          )
        end
      end

      class Mock
        def list_ports(options = {})
          response = Excon::Response.new

          ports = self.data[:ports].values
          response.status = 200
          response.body = { 'ports' => ports }
          response
        end
      end
    end
  end
end
