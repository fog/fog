module Fog
  module Compute
    class HPV2
      class Real
        # List all servers details
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'servers'<~Array>:
        #     * 'hostId'<~String>
        #     * 'addresses'<~Hash>:
        #       * <network_name><~Array> - user defined network name
        #         * 'version'<~Array> - IP version, 4 or 6
        #         * 'addr'<~Array> - public or private ip address
        #     * 'links'<~Array> - array of server links
        #     * 'key_name'<~String> - Name of the keypair associated with the server
        #     * 'image'<~Hash>
        #       * 'id'<~String> - UUId of image used to create the server
        #       * 'links'<~Array> - array of image links
        #     * 'flavor'<~Hash>
        #       * 'id'<~String> - UUId of flavor used to create the server
        #       * 'links'<~Array> - array of flavor links
        #     * 'id'<~String> - UUId of the server
        #     * 'security_groups'<~Array>
        #       * 'name'<~String> - Name of the security group associated with the server
        #     * 'user_id'<~String> - Id of the user that created the server
        #     * 'name<~String> - Name of the server
        #     * 'tenant_id'<~String> - Id of the tenant that created the server
        #     * 'accessIPv4'<~String> - IPv4 IP address
        #     * 'accessIPv6'<~String> - IPv6 IP address
        #     * 'progress'<~Integer> - Progress through current status
        #     * 'created'<~String> - UTC datetime for when the server was created
        #     * 'updated'<~String> - UTC datetime for when the server was last updated
        #     * 'status'<~String> - Current server status
        #     * 'config_drive'<~String> - Config drive setting, 'true' or 'false'
        #     * 'metadata'<~Hash> - metadata for the server
        #     * 'OS-EXT-AZ:availability_zone'<~String> - Availability zone where the server is created. e.g. 'az1', 'az2' etc.
        #     * 'OS-EXT-STS:power_state'<~String> - Extended power state, either 0 or 1
        #     * 'OS-EXT-STS:task_state'<~String> - Extended task state
        #     * 'OS-EXT-STS:vm_state'<~String> - Extended vm state
        def list_servers_detail(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'servers/detail',
            :query    => options
          )
        end
      end

      class Mock
        def list_servers_detail(options = {})
          response = Excon::Response.new

          servers = self.data[:servers].values
          for server in servers
            case server['status']
            when 'BUILD'
              if Time.now - self.data[:last_modified][:servers][server['id']] > Fog::Mock.delay * 2
                server['status'] = 'ACTIVE'
              end
            end
          end

          response.status = 200
          response.body = { 'servers' => servers }
          response
        end
      end
    end
  end
end
