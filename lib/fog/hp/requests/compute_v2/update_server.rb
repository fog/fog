module Fog
  module Compute
    class HPV2
      class Real
        # Update an existing server
        #
        # ==== Parameters
        # * 'server_id'<~String> - UUId of the server to update
        # * options<~Hash>:
        #   * 'name'<~String> - New name for server
        #   * 'accessIPv4'<~String> - IPv4 IP address
        #   * 'accessIPv6'<~String> - IPv6 IP address
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
        #     * 'image'<~Hash>
        #       * 'id'<~String> - UUId of image used to create the server
        #       * 'links'<~Array> - array of image links
        #     * 'flavor'<~Hash>
        #       * 'id'<~String> - UUId of flavor used to create the server
        #       * 'links'<~Array> - array of flavor links
        #     * 'id'<~String> - UUId of the server
        #     * 'user_id'<~String> - Id of the user that created the server
        #     * 'name<~String> - Name of the server
        #     * 'tenant_id'<~String> - Id of the tenant that created the server
        #     * 'accessIPv4'<~String> - IPv4 IP address
        #     * 'accessIPv6'<~String> - IPv6 IP address
        #     * 'progress'<~Integer> - Progress through current status
        #     * 'updated'<~String> - UTC datetime for when the server was last updated
        #     * 'status'<~String> - Current server status
        #     * 'metadata'<~Hash> - metadata
        def update_server(server_id, options = {})
          request(
            :body     => Fog::JSON.encode({ 'server' => options }),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "servers/#{server_id}"
          )
        end
      end

      class Mock
        def update_server(server_id, options)
          response = Excon::Response.new
          if server = list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            if options['name']
              server['name'] = options['name']
            end
            # remove these keys from the response
            server = server.reject { |key, value| ['key_name', 'security_groups', 'created', 'config_drive', 'OS-EXT-AZ:availability_zone', 'OS-EXT-STS:power_state', 'OS-EXT-STS:task_state', 'OS-EXT-STS:vm_state'].include?(key) }
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
