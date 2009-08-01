module Fog
  module AWS
    class EC2

      # Describe all or specified instances
      #
      # ==== Parameters
      # * instance_id<~Array> - List of instance ids to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'reservationSet'<~Array>:
      #       * 'groupSet'<~Array> - Group names for reservation
      #       * 'ownerId'<~String> - AWS Access Key ID of reservation owner
      #       * 'reservationId'<~String> - Id of the reservation
      #       * 'instancesSet'<~Array>:
      #         * instance<~Hash>:
      #           * 'amiLaunchIndex'<~Integer> - reference to instance in launch group
      #           * 'dnsName'<~String> - public dns name, blank until instance is running
      #           * 'imageId'<~String> - image id of ami used to launch instance
      #           * 'instanceId'<~String> - id of the instance
      #           * 'instanceState'<~Hash>:
      #             * 'code'<~Integer> - current status code
      #             * 'name'<~String> - current status name
      #           * 'instanceType'<~String> - type of instance
      #           * 'kernelId'<~String> - Id of kernel used to launch instance
      #           * 'keyName'<~String> - name of key used launch instances or blank
      #           * 'launchTime'<~Time> - time instance was launched
      #           * 'monitoring'<~Hash>:
      #             * 'state'<~Boolean - state of monitoring
      #           * 'placement'<~Hash>:
      #             * 'availabilityZone'<~String> - Availability zone of the instance
      #           * 'productCodes'<~Array> - Product codes for the instance
      #           * 'privateDnsName'<~String> - private dns name, blank until instance is running
      #           * 'ramdiskId'<~String> - Id of ramdisk used to launch instance
      #           * 'reason'<~String> - reason for most recent state transition, or blank
      def describe_instances(instance_id = [])
        params = indexed_params('InstanceId', instance_id)
        request({
          'Action' => 'DescribeInstances'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeInstances.new)
      end

    end
  end
end
