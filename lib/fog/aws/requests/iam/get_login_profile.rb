module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/login_profile'

        # Retrieves the login profile for a user
        # 
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_CreateLoginProfile.html
        # ==== Parameters
        # * user_name<~String> - Name of user to retrieve the login profile for
        # * password<~String> - The new password for this user
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'LoginProfile'<~Hash>
        #        * UserName<~String>
        #        * CreateDate
        #     * 'RequestId'<~String> - Id of the request
        #
        #
        def get_login_profile(user_name)
          request({
            'Action'    => 'GetLoginProfile',
            'UserName'  => user_name,
            :parser     => Fog::Parsers::AWS::IAM::LoginProfile.new
          })
        end

      end
    end
  end
end
