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
          tenant_id = Fog::Identity.new(:provider => 'OpenStack').current_tenant['id']
          security_group_id = Fog::Mock.random_numbers(2).to_i
          self.data[:security_groups][security_group_id] = {
            'tenant_id' => tenant_id,
            'rules'     => [],
            'id'        => security_group_id,
            'name'      => name,
            'description' => description
          }

          response = Excon::Response.new
          response.status = 200
          response.headers = {
            'X-Compute-Request-Id' => "req-#{Fog::Mock.random_hex(32)}",
            'Content-Type'   => 'application/json',
            'Content-Length' => Fog::Mock.random_numbers(3).to_s,
            'Date'           => Date.new}
          response.body = {
            'security_group' => self.data[:security_groups].values
          }
          response
        end
      end # mock
    end # openstack
  end # compute
end # fog
