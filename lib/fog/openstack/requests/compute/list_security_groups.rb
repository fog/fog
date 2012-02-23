module Fog
  module Compute
    class OpenStack
      class Real

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
          response.status = 200
          response.headers = {
            "X-Compute-Request-Id" => "req-63a90344-7c4d-42e2-936c-fd748bced1b3",
            "Content-Type" => "application/json",
            "Content-Length" => "667",
            "Date" => Date.new
          }
          response.body = {
            "security_groups" => [{
              "rules" => [{
                "from_port" => 44,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 55,
                "parent_group_id" => 1,
                "ip_range" => {"cidr"=>"10.10.10.10/24"},
                "id"=>1
              },
              {
                "from_port" => 2,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 3,
                "parent_group_id" => 1,
                "ip_range" => {"cidr"=>"10.10.10.10/24"},
                "id" => 2 
              }],
              "tenant_id" => "d5183375ab0343f3a0b4b05f547aefc2",
              "id" => 1,
              "name" => "default",
              "description" => "default"
            },
            {
              "rules" => [{
                "from_port" => 44,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 55,
                "parent_group_id" => 2,
                "ip_range" => {
                  "cidr"=>"10.10.10.10/24"
                },
                "id"=>3
              }],
            "tenant_id" => "d5183375ab0343f3a0b4b05f547aefc2",
            "id" => 2,
            "name" => "test",
            "description" => "this is a test"
            }
          ]}
          response
        end
      end # mock
    end # openstack
  end # compute
end # fog
