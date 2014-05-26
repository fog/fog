module Fog
  module HP
    class Network
      class Real
        # Update an existing port by id
        #
        # ==== Parameters
        # * 'port_id'<~String>: - UUId of the port
        # * options<~Hash>:
        #   * 'name'<~String>: - Name of the port
        #   * 'admin_state_up'<~Boolean> - The administrative state of the port, true or false
        #   * 'fixed_ips'<~Array>:
        #     * 'subnet_id'<~String>: - UUId of the subnet
        #     * 'ip_address'<~String>: - IP address
        #   * 'device_id'<~String>: - Id of the device
        #   * 'device_owner'<~String>: - Device owner of the port i.e. "network:dhcp"
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
        #       * 'admin_state_up'<~Boolean>: - The administrative state of the port, true or false
        #       * 'binding:vif_type'<~String>: - "other"
        #       * 'device_owner'<~String>: - Device owner of the port i.e. "network:dhcp"
        #       * 'mac_address'<~String>: - MAC address of the port
        #       * 'fixed_ips'<~Array>:
        #         * 'subnet_id'<~String>: - UUId of the subnet
        #         * 'ip_address'<~String>: - IP address
        #       * 'security_groups'<~Array>: - Security Groups
        #       * 'device_id'<~String>: - Id of the device
        def update_port(port_id, options = {})
          data = { 'port' => {} }

          l_options = [:name, :fixed_ips, :device_id,
                       :device_owner, :admin_state_up]
          l_options.select{|o| options[o]}.each do |key|
            data['port'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "ports/#{port_id}"
          )
        end
      end

      class Mock
        def update_port(port_id, options = {})
          response = Excon::Response.new
          if port = list_ports.body['ports'].find { |_| _['id'] == port_id }
            port['name']           = options[:name]
            port['fixed_ips']      = options[:fixed_ips]
            port['device_owner']   = options[:device_owner]
            port['device_id']      = options[:device_id]
            port['admin_state_up'] = options[:admin_state_up]
            response.body = { 'port' => port }
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
