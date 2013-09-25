module Fog
  module Identity
    class OpenStack
      class Real

        ##
        # List EC2 credentials for a user.  Requires administrator
        # credentials.
        #
        # ==== Parameters
        # * user_id<~String>: The id of the user to retrieve the credential
        #   for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'credentials'<~Array>: The user's EC2 credentials
        #       * 'access'<~String>: The access key
        #       * 'secret'<~String>: The secret key
        #       * 'user_id'<~String>: The user id
        #       * 'tenant_id'<~String>: The tenant id

        def list_ec2_credentials(user_id)
          request(
            :expects => [200, 202],
            :method  => 'GET',
            :path    => "users/#{user_id}/credentials/OS-EC2"
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
