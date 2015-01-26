module Fog
  module HP
    class Network
      class Real
        # Create a new floating ip
        #
        # ==== Parameters
        # * 'floating_network_id'<~String>: - UUId of the external network
        # * options<~Hash>:
        #   * 'port_id'<~String>: - Port to associate with the floating IP
        #   * 'tenant_id'<~String>: - TenantId that owns the floating IP
        #   * 'fixed_ip_address'<~String>: - Fixed IP address to associate with the floating IP. Mandatory, if the port has multiple IP addresses
        #   * 'floating_ip_address'<~String>: - Specific floating IP address to allocate, otherwise automatically allocated
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * floatingip<~Array>:
        #       * 'id'<~String>: - UUId for the floating ip
        #       * 'tenant_id'<~String>: - TenantId that owns the floating ip
        #       * 'floating_network_id'<~String>: - UUId of the external network
        #       * 'router_id'<~String>: - Id of the router, null if not assigned
        #       * 'fixed_ip_address'<~String>: - Fixed IP address associated to the floating IP, null if not assigned
        #       * 'floating_ip_address'<~String>: - Floating IP address
        #       * 'port_id'<~String>: - Port associated to the floating IP, null if not assigned
        def create_floating_ip(floating_network_id, options = {})
          data = {
            'floatingip' => {
              'floating_network_id' => floating_network_id
            }
          }

          l_options = [:port_id, :fixed_ip_address, :floating_ip_address, :tenant_id]
          l_options.select{|o| options[o]}.each do |key|
            data['floatingip'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 201,
            :method   => 'POST',
            :path     => 'floatingips'
          )
        end
      end

      class Mock
        def create_floating_ip(floating_network_id, options = {})
          response = Excon::Response.new
          response.status = 201
          data = {
            'id'                  => Fog::HP::Mock.uuid.to_s,
            'floating_network_id' => floating_network_id,
            'port_id'             => options[:port_id] || nil,
            'tenant_id'           => options[:tenant_id] || Fog::Mock.random_numbers(14).to_s,
            'fixed_ip_address'    => options[:fixed_ip_address] || nil,
            'floating_ip_address' => options[:floating_ip_address] || Fog::HP::Mock.ip_address.to_s,
            'router_id'           => Fog::HP::Mock.uuid.to_s
          }
          self.data[:floating_ips][data['id']] = data
          response.body = { 'floatingip' => data }
          response
        end
      end
    end
  end
end
