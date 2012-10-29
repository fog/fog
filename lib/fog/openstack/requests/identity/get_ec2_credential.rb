module Fog
  module Identity
    class OpenStack
      class Real
        def get_ec2_credential(user_id, access)
          request(
            :expects => [200, 202],
            :method  => 'GET',
            :path    => "users/#{user_id}/credentials/OS-EC2/#{access}",
          )
        rescue Excon::Errors::Unauthorized
          raise Fog::Identity::OpenStack::NotFound
        end
      end

      class Mock
        def get_ec2_credential(user_id, access)
          ec2_credential = self.data[:ec2_credentials][user_id][access]

          raise Fog::OpenStack::Identity::NotFound unless ec2_credential

          response = Excon::Response.new
          response.status = 200
          response.body = { 'credential' => ec2_credential }
          response
        end
      end
    end
  end
end
