module Fog
  module HP
    class Network
      class Real
        # Create a new subnet
        #
        # ==== Parameters
        # * 'network_id'<~String>: - UUId of the network
        # * 'cidr'<~String>: - Cidr
        # * 'ip_version'<~Integer>: - IP version, values 4 or 6
        # * options<~Hash>:
        #   * 'name'<~String>: - Name of the subnet
        #   * 'tenant_id'<~String>: - TenantId that owns the subnet
        #   * 'dns_nameservers'<~Array>: - Array of DNS Nameservers
        #   * 'allocation_pools'<~Array>:
        #     * 'start'<~String>: - Start IP address
        #     * 'end'<~String>: - End IP address
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
        def create_subnet(network_id, cidr, ip_version, options = {})
          data = {
            'subnet' => {
              'network_id' => network_id,
              'cidr'       => cidr,
              'ip_version' => ip_version
            }
          }

          l_options = [:name, :gateway_ip, :allocation_pools,
                       :dns_nameservers, :host_routes, :enable_dhcp,
                       :tenant_id]
          l_options.select{|o| options[o]}.each do |key|
            data['subnet'][key] = options[key]
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 201,
            :method   => 'POST',
            :path     => 'subnets'
          )
        end
      end

      class Mock
        def create_subnet(network_id, cidr, ip_version, options = {})
          if list_networks.body['networks'].find {|_| _['id'] == network_id}
            response = Excon::Response.new
            response.status = 201
            data = {
              'id'               => Fog::HP::Mock.uuid.to_s,
              'name'             => options[:name] || "",
              'network_id'       => network_id,
              'cidr'             => cidr,
              'ip_version'       => ip_version,
              'gateway_ip'       => options[:gateway_ip] || Fog::HP::Mock.ip_address.to_s,
              'allocation_pools' => options[:allocation_pools] || [{"start" => "#{Fog::HP::Mock.ip_address.to_s}", "end" => "#{Fog::HP::Mock.ip_address.to_s}"}],
              'dns_nameservers'  => options[:dns_nameservers] || [],
              'host_routes'      => options[:host_routes] || [],
              'enable_dhcp'      => options[:enable_dhcp] || true,
              'tenant_id'        => options[:tenant_id] || Fog::Mock.random_numbers(14).to_s
            }
            self.data[:subnets][data['id']] = data
            # add this subnet to the network
            self.data[:networks][network_id]['subnets'] << data['id']

            response.body = { 'subnet' => data }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
