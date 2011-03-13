module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/login_profile'

        # Creates a login profile for a user
        # 
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_CreateLoginProfile.html
        # ==== Parameters
        # * user_name<~String> - Name of user to create a login profile for
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
        def create_login_profile(user_name, password)
          request({
            'Action'    => 'CreateLoginProfile',
            'UserName'  => user_name,
            'Password'  => password,
            :parser     => Fog::Parsers::AWS::IAM::LoginProfile.new
          })
        end

      end
    end
  end
end
