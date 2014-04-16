module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/set_subscription_attributes'


        # Set attributes of a subscription
        #
        # ==== Parameters
        # * arn<~Hash> - The Arn of subscription to get attributes for
        # * attribute_name<~String> - Name of attribute to set, in ['DeliveryPolicy', 'RawMessageDelivery']
        # * attribute_value<~String> - Value to set attribute to
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/sns/latest/api/API_SetSubscriptionAttributes.html
        #

        def set_subscription_attributes(arn, attribute_name, attribute_value)
          request({
            'Action'          => 'SetSubscriptionAttributes',
            'AttributeName'   => attribute_name,
            'AttributeValue'  => attribute_value,
            'SubscriptionArn' => arn.strip,
            :parser     => Fog::Parsers::AWS::SNS::SetSubscriptionAttributes.new
          })
        end


      end
    end
  end
end
