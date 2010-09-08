module Fog
  module AWS
    class Compute
      class Real

        require 'fog/aws/parsers/compute/describe_reserved_instances'

        # Describe all or specified reserved instances
        #
        # ==== Parameters
        # * reserved_instances_id<~Array> - List of reserved instance ids to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'reservedInstancesSet'<~Array>:
        #       * 'availabilityZone'<~String> - availability zone of the instance
        #       * 'duration'<~Integer> - duration of reservation, in seconds
        #       * 'fixedPrice'<~Float> - purchase price of reserved instance
        #       * 'instanceType'<~String> - type of instance
        #       * 'instanceCount'<~Integer> - number of reserved instances
        #       * 'productDescription'<~String> - reserved instance description
        #       * 'reservedInstancesId'<~String> - id of the instance
        #       * 'start'<~Time> - start time for reservation
        #       * 'state'<~String> - state of reserved instance purchase, in .[pending-payment, active, payment-failed, retired]
        #       * 'usagePrice"<~Float> - usage price of reserved instances, per hour
        def describe_reserved_instances(reserved_instances_id = [])
          params = AWS.indexed_param('ReservedInstancesId', reserved_instances_id)
          request({
            'Action'    => 'DescribeReservedInstances',
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::Compute::DescribeReservedInstances.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_reserved_instances(reserved_instances_id = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
