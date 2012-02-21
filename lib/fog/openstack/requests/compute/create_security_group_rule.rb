module Fog
  module Compute
    class OpenStack
      class Real

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
            :body     => MultiJson.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-security-group-rules.json'
          )
        end

      end

      class Mock



      end

    end
  end
end
