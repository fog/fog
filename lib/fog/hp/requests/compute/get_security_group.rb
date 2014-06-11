module Fog
  module Compute
    class HP
      class Real
        # Get details about a security group
        #
        # ==== Parameters
        # * 'security_group_id'<~Integer> - Id of security group to get details for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'security_group'<~Array>:
        #     * 'rules'<~Array>: - array of security group rules
        #       * 'id'<~Integer> - id of the security group rule
        #       * 'from_port'<~Integer> - start port for rule i.e. 22 (or -1 for ICMP wildcard)
        #       * 'to_port'<~Integer> - end port for rule i.e. 22 (or -1 for ICMP wildcard)
        #       * 'ip_protocol'<~String> - ip protocol for rule, must be in ['tcp', 'udp', 'icmp']
        #       * 'group'<~Hash>:
        #          * Undefined
        #       * 'parent_group_id'<~Integer> - parent group id
        #       * 'ip_range'<~Hash>:
        #         * 'cidr'<~String> - ip range address i.e. '0.0.0.0/0'
        #     * 'id'<~Integer> - id of the security group
        #     * 'name'<~String> - name of the security group
        #     * 'description'<~String> - description of the security group
        #     * 'tenant_id'<~String> - tenant id of the user
        #
        # {Openstack API Reference}[http://docs.openstack.org]
        def get_security_group(security_group_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "os-security-groups/#{security_group_id}"
          )
        end
      end

      class Mock
        def get_security_group(security_group_id)
          response = Excon::Response.new
          if sec_group = self.data[:security_groups][security_group_id]
            response.status = 200
            response.body = { 'security_group' => sec_group }
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
