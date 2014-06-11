module Fog
  module HP
    class Network
      class Real
        # Gets an existing subnet by id
        #
        # ==== Parameters
        # * 'id'<~String>: - UUId for the subnet
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
        def get_subnet(subnet_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "subnets/#{subnet_id}"
          )
        end
      end

      class Mock
        def get_subnet(subnet_id)
          response = Excon::Response.new
          if subnet = list_subnets.body['subnets'].find {|_| _['id'] == subnet_id}
            response.status = 200
            response.body = { 'subnet' => subnet }
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
