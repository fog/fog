module Fog
  module AWS
    class STS
      class Real

        require 'fog/aws/parsers/sts/get_session_token'

        def get_federation_token(name, policy, duration=43200)
          request({
            'Action'          => 'GetFederationToken',
            'Name'            => name,
            'Policy'          => MultiJson.encode(policy),
            'DurationSeconds' => duration,
            :idempotent       => true,
            :parser           => Fog::Parsers::AWS::STS::GetSessionToken.new
          })
        end
      end
    end
  end
end
