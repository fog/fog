module Fog
  module AWS
    class STS
      class Real
        require 'fog/aws/parsers/sts/assume_role'

        # Assume Role
        #
        # ==== Parameters
        # * role_session_name<~String> - An identifier for the assumed role.
        # * role_arn<~String> - The ARN of the role the caller is assuming.
        # * external_id<~String> - An optional unique identifier required by the assuming role's trust identity.
        # * policy<~String> - An optional JSON policy document
        # * duration<~Integer> - Duration (of seconds) for the assumed role credentials to be valid (default 3600)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Arn'<~String>: The ARN of the assumed role/user
        #     * 'AccessKeyId'<~String>: The AWS access key of the temporary credentials for the assumed role
        #     * 'SecretAccessKey'<~String>: The AWS secret key of the temporary credentials for the assumed role
        #     * 'SessionToken'<~String>: The AWS session token of the temporary credentials for the assumed role
        #     * 'Expiration'<~Time>: The expiration time of the temporary credentials for the assumed role
        #
        # ==== See Also
        # http://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html
        #

        def assume_role(role_session_name, role_arn, external_id=nil, policy=nil, duration=3600)
          request({
            'Action'          => 'AssumeRole',
            'RoleSessionName' => role_session_name,
            'RoleArn'         => role_arn,
            'Policy'          => policy && Fog::JSON.encode(policy),
            'DurationSeconds' => duration,
            'ExternalId'      => external_id,
            :idempotent       => true,
            :parser           => Fog::Parsers::AWS::STS::AssumeRole.new
          })
        end
      end
    end
  end
end
