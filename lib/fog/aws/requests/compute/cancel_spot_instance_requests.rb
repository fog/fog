module Fog
  module Compute
    class AWS
      class Real
        require 'fog/aws/parsers/compute/cancel_spot_instance_requests'

        # Terminate specified spot instance requests
        #
        # ==== Parameters
        # * spot_instance_request_id<~Array> - Ids of instances to terminates
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> id of request
        #     * 'spotInstanceRequestSet'<~Array>:
        #       * 'spotInstanceRequestId'<~String> - id of cancelled spot instance
        #       * 'state'<~String> - state of cancelled spot instance
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CancelSpotInstanceRequests.html]
        def cancel_spot_instance_requests(spot_instance_request_id)
          params = Fog::AWS.indexed_param('SpotInstanceRequestId', spot_instance_request_id)
          request({
            'Action'    => 'CancelSpotInstanceRequests',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::CancelSpotInstanceRequests.new
          }.merge!(params))
        end
      end
    end
  end
end
