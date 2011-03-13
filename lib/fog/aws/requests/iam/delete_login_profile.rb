module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/basic'

        # Deletes a user's login profile
        # 
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_DeleteLoginProfile.html
        # ==== Parameters
        # * user_name<~String> - Name of user whose login profile you want to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        #
        def delete_login_profile(user_name)
          request({
            'Action'    => 'DeleteLoginProfile',
            'UserName'  => user_name,
            :parser     => Fog::Parsers::AWS::IAM::Basic.new
          })
        end

      end
    end
  end
end
