module Fog
  module Compute
    class HP
      class Real
        # Create a new security group
        #
        # ==== Parameters
        # * 'name'<~String> - name of the security group
        # * 'description'<~String> - description of the security group
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
        def create_security_group(name, description)
          data = {
            'security_group' => {
              'name'       => name,
              'description' => description
            }
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-security-groups.json'
          )
        end
      end

      class Mock
        def create_security_group(name, description)
          # all spaces are removed
          name = name.strip
          description = description.strip

          response = Excon::Response.new
          if self.data[:security_groups].find {|_,v| v['name'] == name}
            response.status = 400
            response.body = { "badRequest" => {"message" => "Security group #{name} already exists", "code" => 400}}
            raise(Excon::Errors.status_error({:expects => 200}, response))
          else
            response.status = 200
            data = {
              'rules'        => [],
              'id'           => Fog::Mock.random_numbers(3).to_i,
              'tenant_id'    => Fog::HP::Mock.user_id.to_s,
              'name'         => name,
              'description'  => description
            }
            self.data[:last_modified][:security_groups][data['id']] = Time.now
            self.data[:security_groups][data['id']] = data

            response.body = { 'security_group' => data }
          end
          response
        end
      end
    end
  end
end
