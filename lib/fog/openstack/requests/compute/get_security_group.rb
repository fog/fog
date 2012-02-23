module Fog
  module Compute
    class OpenStack
      class Real

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
          response.status = 200
          response.headers = {
            "X-Compute-Request-Id" => "req-63a90344-7c4d-42e2-936c-fd748bced1b3",
            "Content-Type" => "application/json",
            "Content-Length" => "167",
            "Date" => Date.new
          }
          response.body = {
            "security_group" => {
              "rules" => [{
                "from_port" => 44,
                "group" => {},
                "ip_protocol" => "tcp",
                "to_port" => 55,
                "parent_group_id" => 1,
                "ip_range" => {
                  "cidr" => "10.10.10.10/24"
                }, "id"=>1
              }],
              "tenant_id" => "d5183375ab0343f3a0b4b05f547aefc2",
              "id"=>security_group_id,
              "name"=>"default",
              "description"=>"default"
            }
          }
          response
        end
      end # mock
    end # openstack
  end #compute
end #fog
