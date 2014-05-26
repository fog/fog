module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/single_role'

        # Get the specified role
        #
        # ==== Parameters
        # role_name<~String>

        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * Role<~Hash>:
        #       * 'Arn'<~String> -
        #       * 'AssumeRolePolicyDocument'<~String<
        #       * 'Path'<~String> -
        #       * 'RoleId'<~String> -
        #       * 'RoleName'<~String> -
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_GetRole.html
        #
        def get_role(role_name)
          request(
            'Action'    => 'GetRole',
            'RoleName'  => role_name,
            :parser     => Fog::Parsers::AWS::IAM::SingleRole.new
          )
        end
      end
    end
  end
end
