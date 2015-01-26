module Fog
  module HP
    class Network
      class Real
        # Create a new port
        #
        # ==== Parameters
        # * 'network_id'<~String>: - UUId of the network
        # * options<~Hash>:
        #   * 'name'<~String>: - Name of the port
        #   * 'tenant_id'<~String>: - TenantId that owns the port
        #   * 'admin_state_up'<~Boolean> - The administrative state of the port, true or false
        #   * 'mac_address'<~String>: - MAC address of the port
        #   * 'fixed_ips'<~Array>:
        #     * 'subnet_id'<~String>: - UUId of the subnet
        #     * 'ip_address'<~String>: - IP address
        #   * 'device_id'<~String>: - Id of the device
        #   * 'device_owner'<~String>: - Device owner of the port i.e. "network:dhcp"
        #   * 'security_groups'<~Array>: - Security Groups
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
        def create_port(network_id, options = {})
          data = {
            'port' => {
              'network_id' => network_id
            }
          }

          l_options = [:name, :mac_address, :fixed_ips, :security_groups,
                       :device_id, :device_owner, :admin_state_up, :tenant_id]
          l_options.select{|o| options[o]}.each do |key|
            data['port'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 201,
            :method   => 'POST',
            :path     => 'ports'
          )
        end
      end

      class Mock
        def create_port(network_id, options = {})
          response = Excon::Response.new
          if list_networks.body['networks'].find {|_| _['id'] == network_id}
            response.status = 201
            data = {
              'id'             => Fog::HP::Mock.uuid.to_s,
              'name'           => options[:name] || "",
              'network_id'     => network_id,
              'fixed_ips'      => options[:fixed_ips] || [{'subnet_id' => "#{Fog::HP::Mock.uuid.to_s}", 'ip_address' => "#{Fog::HP::Mock.ip_address.to_s}"}],
              'mac_address'    => options[:mac_address] || Fog::HP::Mock.mac_address.to_s,
              'status'         => 'ACTIVE',
              'admin_state_up' => options[:admin_state_up] || true,
              'binding:vif_type'  => 'other',
              'device_owner'   => options[:device_owner] || "",
              'device_id'      => options[:device_id] || "",
              'security_groups'  => ["#{Fog::HP::Mock.uuid.to_s}"],
              'tenant_id'      => options[:tenant_id] || Fog::Mock.random_numbers(14).to_s
            }
            self.data[:ports][data['id']] = data
            response.body = { 'port' => data }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
