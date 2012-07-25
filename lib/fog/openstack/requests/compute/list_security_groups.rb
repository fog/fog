module Fog
  module Compute
    class OpenStack
      class Real

        def list_security_groups(server_id = nil)
          path = "os-security-groups.json"
          if server_id
            path = "servers/#{server_id}/#{path}"
          end
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => path
          )
        end

      end

      class Mock
        def list_security_groups
          self.data[:security_groups] = [
            { "rules" => [
              { "from_port" => 44,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 55,
                "parent_group_id" => 1,
                "ip_range" => {"cidr"=>"10.10.10.10/24"},
                "id" => Fog::Mock.random_numbers(2).to_i
              },
              { "from_port" => 2,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 3,
                "parent_group_id" => 1,
                "ip_range" => {"cidr"=>"10.10.10.10/24"},
                "id" => Fog::Mock.random_numbers(2).to_i
              } ],
              "tenant_id" => @openstack_tenant,
              "id" => Fog::Mock.random_numbers(2).to_i,
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
                "id"=> Fog::Mock.random_numbers(2).to_i
              } ],
            "tenant_id" => @openstack_tenant,
            "id" => Fog::Mock.random_numbers(2).to_i,
            "name" => "test",
            "description" => "this is a test"
            }
          ] unless self.data.empty?
          Excon::Response.new(
            :body     => { 'security_groups' => self.data[:security_groups] },
            :headers  => {
              "X-Compute-Request-Id" => "req-#{Fog::Mock.random_base64(36)}",
              "Content-Type" => "application/json",
              "Date" => Date.new
            },
            :status   => 200
          )
        end
      end # mock
    end # openstack
  end # compute
end # fog
