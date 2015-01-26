module Fog
  module Compute
    class HP
      class Real
        # List all security groups
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'security_groups'<~Array>:
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
        def list_security_groups
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'os-security-groups.json'
          )
        end
      end

      class Mock
        def list_security_groups
          response = Excon::Response.new

          sec_groups = []
          sec_groups = self.data[:security_groups].values unless self.data[:security_groups].nil?

          response.status = 200
          response.body = { 'security_groups' => sec_groups }
          response
        end
      end
    end
  end
end
