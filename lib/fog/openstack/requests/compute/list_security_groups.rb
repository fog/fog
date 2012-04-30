module Fog
  module Compute
    class OpenStack
      class Real

        def list_security_groups(server_id = nil)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "#{%Q|servers/#{server_id}/| if server_id }os-security-groups.json"
          )
        end

      end

      class Mock
        def list_security_groups
          response = Excon::Response.new
          response.status = 200
          response.headers = {
            "X-Compute-Request-Id" => "req-#{Fog::Mock.random_base64(36)}",
            "Content-Type" => "application/json",
            "Date" => Date.new
          }
          self.data[:security_groups] ||= [
            { "rules" => [
              { "from_port" => 44,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 55,
                "parent_group_id" => 1,
                "ip_range" => {"cidr"=>"10.10.10.10/24"},
                "id" => Fog::Mock.random_base64(36)
              },
              { "from_port" => 2,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 3,
                "parent_group_id" => 1,
                "ip_range" => {"cidr"=>"10.10.10.10/24"},
                "id" => Fog::Mock.random_base64(36)
              } ],
              "tenant_id" => @openstack_tenant,
              "id" => Fog::Mock.random_base64(36),
              "name" => "default",
              "description" => "default"
            },
            {
              "rules" => [
              { "from_port" => 44,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 55,
                "parent_group_id" => 2,
                "ip_range" => { "cidr"=>"10.10.10.10/24" },
                "id"=> Fog::Mock.random_base64(36)
              } ],
            "tenant_id" => @openstack_tenant,
            "id" => Fog::Mock.random_base64(36),
            "name" => "test",
            "description" => "this is a test"
            }
          ]
          response.body = { 'security_groups' => self.data[:security_groups] }
          response
        end
      end # mock
    end # openstack
  end # compute
end # fog
