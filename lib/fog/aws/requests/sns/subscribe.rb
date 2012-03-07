module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/subscribe'

        # Create a subscription
        #
        # ==== Parameters
        # * arn<~String> - Arn of topic to subscribe to
        # * endpoint<~String> - Endpoint to notify
        # * protocol<~String> - Protocol to notify endpoint with, in ['email', 'email-json', 'http', 'https', 'sqs']
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/sns/latest/api/API_Subscribe.html
        #

        def subscribe(arn, endpoint, protocol)
          request({
            'Action'    => 'Subscribe',
            'Endpoint'  => endpoint,
            'Protocol'  => protocol,
            'TopicArn'  => arn.strip,
            :parser     => Fog::Parsers::AWS::SNS::Subscribe.new
          })
        end

      end

    end
  end
end
