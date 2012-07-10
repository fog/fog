module Fog
  module Compute
    class OpenStack
      class Real

        def create_security_group(name, description)
          data = {
            'security_group' => {
              'name'       => name,
              'description' => description
            }
          }

          request(
            :body     => MultiJson.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-security-groups.json'
          )
        end

      end

      class Mock
        def create_security_group(name, description)
          response = Excon::Response.new
          response.status = 200
          response.headers = {
            "X-Compute-Request-Id" => "req-c373a42c-2825-4e60-8d34-99416ea850be",
            "Content-Type" => "application/json",
            "Content-Length" => "139",
            "Date" => Date.new}
          response.body = {
            "security_group" => [{
              "rules" => [],
              "tenant_id" => "d5183375ab0343f3a0b4b05f547aefc2",
              "id" => 999,
              "name" => name,
              "description" => description
            }]
          }
          response
        end
      end # mock
    end # openstack
  end # compute
end # fog
