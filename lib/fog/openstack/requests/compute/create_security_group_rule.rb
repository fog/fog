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
            :expects  => 200,
            :method   => 'POST',
            :body     => MultiJson.encode(data),
            :path     => 'os-security-group-rules.json'
          )
        end

      end

      class Mock
        def create_security_group_rule(parent_group_id, ip_protocol, from_port, to_port, cidr, group_id=nil)
          response = Excon::Response.new
          response.status = 200
          response.headers = {
            "X-Compute-Request-Id" => "req-63a90344-7c4d-42e2-936c-fd748bced1b3",
            "Content-Type" => "application/json",
            "Content-Length" => "163",
            "Date" => Date.new
          }
          response.body = {
            "security_group_rule" => {
              "from_port" => from_port,
              "group"     => group_id || {},
              "ip_protocol" => ip_protocol,
              "to_port" => to_port,
              "parent_group_id" => parent_group_id,
              "ip_range" => {
                "cidr" => cidr
              },
              "id"=>1
            }
          }
          response
        end
      end # mock
    end # openstack
  end # compute
end # fog
