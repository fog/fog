module Fog
  module Identity
    class OpenStack
      class Real
        def create_ec2_credential(user_id, tenant_id)
          data = { 'tenant_id' => tenant_id }

          request(
            :body    => MultiJson.encode(data),
            :expects => [200, 202],
            :method  => 'POST',
            :path    => "users/#{user_id}/credentials/OS-EC2",
          )
        end
      end

      class Mock
        def create_ec2_credential(user_id, tenant_id)
          response = Excon::Response.new
          response.status = 200

          data = {
            'access'    => Fog::Mock.random_hex(32),
            'secret'    => Fog::Mock.random_hex(32),
            'tenant_id' => tenant_id,
            'user_id'   => user_id,
          }

          self.data[:ec2_credentials][user_id][data['access']] = data

          response.body = { 'credential' => data }

          response
        end
      end
    end
  end
end
