module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/spot_instance_requests'

        # Describe all or specified spot instance requests
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'spotInstanceRequestSet'<~Array>:
        #       * 'createTime'<~Time> - time of instance request creation
        #       * 'instanceId'<~String> - instance id if one has been launched to fulfill request
        #       * 'launchedAvailabilityZone'<~String> - availability zone of instance if one has been launched to fulfill request
        #       * 'launchSpecification'<~Hash>:
        #         * 'blockDeviceMapping'<~Hash> - list of block device mappings for instance
        #         * 'groupSet'<~String> - security group(s) for instance
        #         * 'keyName'<~String> - keypair name for instance
        #         * 'imageId'<~String> - AMI for instance
        #         * 'instanceType'<~String> - type for instance
        #         * 'monitoring'<~Boolean> - monitoring status for instance
        #         * 'subnetId'<~String> - VPC subnet ID for instance
        #       * 'productDescription'<~String> - general description of AMI
        #       * 'spotInstanceRequestId'<~String> - id of spot instance request
        #       * 'spotPrice'<~Float> - maximum price for instances to be launched
        #       * 'state'<~String> - spot instance request state
        #       * 'type'<~String> - spot instance request type
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeSpotInstanceRequests.html]
        def describe_spot_instance_requests(filters = {})
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action'    => 'DescribeSpotInstanceRequests',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::SpotInstanceRequests.new
          }.merge!(params))
        end

      end
    end
  end
end
