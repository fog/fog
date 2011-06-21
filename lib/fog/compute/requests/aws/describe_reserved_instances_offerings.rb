module Fog
  module Compute
    class AWS
      class Real

        require 'fog/compute/parsers/aws/describe_reserved_instances_offerings'

        # Describe all or specified reserved instances offerings
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'reservedInstancesOfferingsSet'<~Array>:
        #       * 'availabilityZone'<~String> - availability zone of offering
        #       * 'duration'<~Integer> - duration, in seconds, of offering
        #       * 'fixedPrice'<~Float> - purchase price of offering
        #       * 'instanceType'<~String> - instance type of offering
        #       * 'productDescription'<~String> - description of offering
        #       * 'reservedInstancesOfferingId'<~String> - id of offering
        #       * 'usagePrice'<~Float> - usage price of offering, per hour
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeReservedInstancesOfferings.html]
        def describe_reserved_instances_offerings(filters = {})
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action'    => 'DescribeReservedInstancesOfferings',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::DescribeReservedInstancesOfferings.new
          }.merge!(params))
        end

      end
    end
  end
end
