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
        def list_security_groups(server_id = nil)
          security_groups = self.data[:security_groups].values

          groups = if server_id then
                     server_group_names =
                       self.data[:server_security_group_map][server_id]

                     server_group_names.map do |name|
                       security_groups.find do |sg|
                         sg['name'] == name
                       end
                     end.compact
                   else
                     security_groups
                   end

          Excon::Response.new(
            :body     => { 'security_groups' => groups },
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
