module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/get_user_policy'

        # Get User Policy
        # 
        # ==== Parameters
        # * 'PolicyName'<~String>: Name of the policy to get
        # * 'UserName'<~String>: Name of the User who the policy is associated with.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #       * PolicyDocument<~String> The policy document.
        #       * PolicyName<~String> The name of the policy.
        #       * UserName<~String> The User the policy is associated with.
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_GetUserPolicy.html
        #
        def get_user_policy(policy_name, user_name)
          request({
            'Action'      => 'GetUserPolicy',
            'PolicyName'  => policy_name,
            'UserName'    => user_name,
            :parser       => Fog::Parsers::AWS::IAM::GetUserPolicy.new
          })
        end

      end
    end
  end
end
