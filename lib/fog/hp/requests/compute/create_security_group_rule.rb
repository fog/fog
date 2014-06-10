module Fog
  module Compute
    class HP
      class Real
        # Create a new security group rule and attach it to a security group
        #
        # ==== Parameters
        #   * 'parent_group_id'<~Integer> - id of the parent security group
        #   * 'ip_protocol'<~String> - ip protocol for rule, must be in ['tcp', 'udp', 'icmp']
        #   * 'from_port'<~Integer> - start port for rule i.e. 22 (or -1 for ICMP wildcard)
        #   * 'to_port'<~Integer> - end port for rule i.e. 22 (or -1 for ICMP wildcard)
        #   * 'cidr'<~String> - ip range address i.e. '0.0.0.0/0'
        #   * 'group_id'<~Integer> - id of the security group to which this rule applies
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #
        # {Openstack API Reference}[http://docs.openstack.org]
        def create_security_group_rule(parent_group_id, ip_protocol, from_port, to_port, cidr, group_id=nil)
          data = {
            'security_group_rule' => {
              'parent_group_id' => parent_group_id,
              'ip_protocol'     => ip_protocol,
              'from_port'       => from_port,
              'to_port'         => to_port,
              'cidr'            => cidr,
              'group_id'        => group_id
            }
          }

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-security-group-rules.json'
          )
        end
      end

      class Mock
        def create_security_group_rule(parent_group_id, ip_protocol, from_port, to_port, cidr, group_id=nil)
          response = Excon::Response.new
          group = self.data[:security_groups][parent_group_id]
          if group
            group['rules'] ||= []
            response.status = 200
            data = {
              'from_port'       => from_port.to_i,
              'group'           => {},
              'ip_protocol'     => ip_protocol,
              'to_port'         => to_port.to_i,
              'parent_group_id' => parent_group_id,
              'ip_range'        => {
                'cidr' => cidr
              },
              'id'              => Fog::Mock.random_numbers(3).to_i
            }
            group['rules'][data['id']] = data

            response.body = { 'security_group_rule' => data }
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
