module Fog
  module Identity
    class OpenStack
      class Real
        def list_ec2_credentials(user_id)
          request(
            :expects => [200, 202],
            :method  => 'GET',
            :path    => "users/#{user_id}/credentials/OS-EC2",
          )
        end
      end

      class Mock
        def list_ec2_credentials(user_id)
          ec2_credentials = self.data[:ec2_credentials][user_id].values

          response = Excon::Response.new
          response.status = 200
          response.body = { 'credentials' => ec2_credentials }
          response
        end
      end
    end
  end
end
