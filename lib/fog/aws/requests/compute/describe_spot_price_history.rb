module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_spot_price_history'

        # Describe all or specified spot price history
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'spotPriceHistorySet'<~Array>:
        #       * 'availabilityZone'<~String> - availability zone for instance
        #       * 'instanceType'<~String> - the type of instance
        #       * 'productDescription'<~String> - general description of AMI
        #       * 'spotPrice'<~Float> - maximum price to launch one or more instances
        #       * 'timestamp'<~Time> - date and time of request creation
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeSpotPriceHistory.html]
        def describe_spot_price_history(filters = {})
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action'    => 'DescribeSpotPriceHistory',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::DescribeSpotPriceHistory.new
          }.merge!(params))
        end

      end
    end
  end
end
