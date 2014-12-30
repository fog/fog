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

      class Mock
        def subscribe(arn, endpoint, protocol)
          response = Excon::Response.new

          unless topic = self.data[:topics][arn]
            response.status = 400
            response.body = {
              'Code'    => 'InvalidParameterValue',
              'Message' => 'Invalid parameter: TopicArn',
              'Type'    => 'Sender',
            }

            return response
          end

          subscription_arn = Fog::AWS::Mock.arn(@module, @account_id, "#{topic["DisplayName"]}:#{Fog::AWS::Mock.request_id}", @region)

          self.data[:subscriptions][subscription_arn] = {
            "Protocol"        => protocol,
            "Owner"           => @account_id.to_s,
            "TopicArn"        => arn,
            "SubscriptionArn" => subscription_arn,
            "Endpoint"        => endpoint,
          }

          response.body = { 'SubscriptionArn' => 'pending confirmation', 'RequestId' => Fog::AWS::Mock.request_id }
          response
        end
      end
    end
  end
end
