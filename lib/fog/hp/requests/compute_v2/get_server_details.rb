module Fog
  module Compute
    class HPV2
      class Real
        # Get details about a server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of the server to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'server'<~Hash>:
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
        #     * 'metadata'<~Hash> - metadata
        #     * 'OS-EXT-AZ:availability_zone'<~String> - Availability zone where the server is created. e.g. 'az1', 'az2' etc.
        #     * 'OS-EXT-STS:power_state'<~String> - Extended power state, either 0 or 1
        #     * 'OS-EXT-STS:task_state'<~String> - Extended task state
        #     * 'OS-EXT-STS:vm_state'<~String> - Extended vm state
        def get_server_details(server_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "servers/#{server_id}"
          )
        end
      end

      class Mock
        def get_server_details(server_id)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            response.status = 200
            response.body = { 'server' => server }
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
