module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/get_user'

        # Get User
        # 
        # ==== Parameters
        # * options<~Hash>:
        #   * 'UserName'<~String>: Name of the User. Defaults to current user
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'User'<~Hash> - User
        #       * Arn<~String> -
        #       * UserId<~String> -
        #       * UserName<~String> -
        #       * Path<~String> -
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_Getuser.html
        #
        def get_user(options = {})
          request({
            'Action'  => 'GetUser',
            :parser   => Fog::Parsers::AWS::IAM::GetUser.new
          }.merge!(options))
        end

      end
    end
  end
end
