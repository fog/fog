module Fog
  module AWS
    class SNS
      class Real

        require 'fog/aws/parsers/sns/list_subscriptions'

        # List subscriptions
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'NextToken'<~String> - Token returned from previous request, used for pagination
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/sns/latest/api/API_ListSubscriptions.html
        #

        def list_subscriptions(options = {})
          request({
            'Action' => 'ListSubscriptions',
            :parser  => Fog::Parsers::AWS::SNS::ListSubscriptions.new
          }.merge!(options))
        end

      end

    end
  end
end
