module Fog
  module AWS
    class STS
      class Real

        require 'fog/aws/parsers/sts/get_session_token'

        # Get federation token
        #
        # ==== Parameters
        # * name<~String>: The name of the federated user.
        #                  Minimum length of 2. Maximum length of 32.
        # * policy<~String>: Optional policy that specifies the permissions
        #                    that are granted to the federated user
        #                    Minimum length of 1. Maximum length of 2048.
        # * duration<~Integer>: Optional duration, in seconds, that the session
        #                       should last.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'SessionToken'<~String> -
        #     * 'SecretAccessKey'<~String> -
        #     * 'Expiration'<~String> -
        #     * 'AccessKeyId'<~String> -
        #     * 'Arn'<~String> -
        #     * 'FederatedUserId'<~String> -
        #     * 'PackedPolicySize'<~String> -
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.aws.amazon.com/STS/latest/APIReference/API_GetFederationToken.html

        def get_federation_token(name, policy, duration=43200)
          request({
            'Action'          => 'GetFederationToken',
            'Name'            => name,
            'Policy'          => Fog::JSON.encode(policy),
            'DurationSeconds' => duration,
            :idempotent       => true,
            :parser           => Fog::Parsers::AWS::STS::GetSessionToken.new
          })
        end
      end
    end
  end
end
