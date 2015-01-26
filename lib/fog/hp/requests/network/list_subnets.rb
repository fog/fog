module Fog
  module HP
    class Network
      class Real
        # List existing subnets
        #
        # ==== Parameters
        # * options<~Hash>:
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * subnets<~Array>:
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
        def list_subnets(options = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'subnets',
            :query   => options
          )
        end
      end

      class Mock
        def list_subnets(options = {})
          response = Excon::Response.new

          subnets = self.data[:subnets].values
          response.status = 200
          response.body = { 'subnets' => subnets }
          response
        end
      end
    end
  end
end
