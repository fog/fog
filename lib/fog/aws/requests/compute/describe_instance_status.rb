module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_instance_status'

        def describe_instance_status(filters = {})
          raise ArgumentError.new("Filters must be a hash, but is a #{filters.class}.") unless filters.is_a?(Hash)

          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action'    => 'DescribeInstanceStatus',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::DescribeInstanceStatus.new
          }.merge!(params))
        end
      end

      class Mock
        def describe_instance_status(filters = {})
          response = Excon::Response.new
          response.status = 200

          response.body = {
            'instanceStatusSet' => [],
            'requestId' => Fog::AWS::Mock.request_id
          }

          response

        end
      end
    end
  end
end
