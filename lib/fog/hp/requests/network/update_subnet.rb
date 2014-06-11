module Fog
  module HP
    class Network
      class Real
        # Update an existing subnet
        #
        # ==== Parameters
        # * 'id'<~String>: - UUId for the subnet
        # * options<~Hash>:
        #   * 'name'<~String>: - Name of the subnet
        #   * 'dns_nameservers'<~Array>: - Array of DNS Nameservers
        #   * 'host_routes'<~Array>: - Array of host routes
        #   * 'gateway_ip'<~String>: - Gateway IP address
        #   * 'enable_dhcp'<~Boolean>: - true or false, defaults to true
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * subnet<~Array>:
        #       * 'id'<~String>: - UUId for the subnet
        #       * 'name'<~String>: - Name of the subnet
        #       * 'network_id'<~String>: - UUId of the network
        #       * 'tenant_id'<~String>: - TenantId that owns the subnet
        #       * 'dns_nameservers'<~Array>: - Array of DNS Nameservers
        #       * 'allocation_pools'<~Array>:
        #         * 'start'<~String>: - Start IP address
        #         * 'end'<~String>: - End IP address
        #       * 'host_routes'<~Array>: - Array of host routes
        #       * 'gateway_ip'<~String>: - Gateway IP address
        #       * 'ip_version'<~Integer>: - IP version, values 4 or 6
        #       * 'cidr'<~String>: - Cidr
        #       * 'enable_dhcp'<~Boolean>: - true or false, defaults to true
        def update_subnet(subnet_id, options = {})
          data = { 'subnet' => {} }

          l_options = [:name, :gateway_ip, :dns_nameservers,
                       :host_routes, :enable_dhcp]
          l_options.select{|o| options[o]}.each do |key|
            data['subnet'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "subnets/#{subnet_id}"
          )
        end
      end

      class Mock
        def update_subnet(subnet_id, options = {})
          response = Excon::Response.new
          if subnet = list_subnets.body['subnets'].find {|_| _['id'] == subnet_id}
            subnet['name']            = options[:name]
            subnet['gateway_ip']      = options[:gateway_ip]
            subnet['dns_nameservers'] = options[:dns_nameservers]
            subnet['host_routes']     = options[:host_routes]
            subnet['enable_dhcp']     = options[:enable_dhcp]
            response.body = { 'subnet' => subnet }
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
