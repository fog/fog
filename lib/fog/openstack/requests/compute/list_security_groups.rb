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
          Excon::Response.new(
            :body     => { 'security_groups' => self.data[:security_groups].values },
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
