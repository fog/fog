module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_reserved_instances_offerings'

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

      class Mock
        def describe_reserved_instances_offerings(filters = {})
          response = Excon::Response.new
          response.status = 200

          self.data[:reserved_instances_offerings] ||= [{
            'reservedInstancesOfferingId' => Fog::AWS::Mock.reserved_instances_offering_id,
            'instanceType'        => 'm1.small',
            'availabilityZone'    => 'us-east-1d',
            'duration'            => 31536000,
            'fixedPrice'          => 350.0,
            'usagePrice'          => 0.03,
            'productDescription'  => 'Linux/UNIX',
            'instanceTenancy'     => 'default',
            'currencyCode'         => 'USD'
          }]

          response.body = {
            'reservedInstancesOfferingsSet' => self.data[:reserved_instances_offerings],
            'requestId' => Fog::AWS::Mock.request_id
          }

          response
        end
      end
    end
  end
end
