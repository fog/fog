module Fog
  module AWS
    class EC2

      # Launch specified instances
      #
      # ==== Parameters
      # * image_id<~String> - Id of machine image to load on instances
      # * min_count<~Integer> - Minimum number of instances to launch. If this
      #   exceeds the count of available instances, no instances will be 
      #   launched.  Must be between 1 and maximum allowed for your account
      #   (by default the maximum for an account is 20)
      # * max_count<~Integer> - Maximum number of instances to launch. If this
      #   exceeds the number of available instances, the largest possible
      #   number of instances above min_count will be launched instead. Must 
      #   be between 1 and maximum allowed for you account
      #   (by default the maximum for an account is 20)
      # * options<~Hash>:
      #   * 'Placement.AvailabilityZone'<~String> - Placement constraint for instances
      #   * 'DeviceName'<~String> - ?
      #   * 'Encoding'<~String> - ?
      #   * 'GroupId'<~String> - Name of security group for instances
      #   * 'InstanceType'<~String> - Type of instance to boot. Valid options
      #     in ['m1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge']
      #     default is 'm1.small'
      #   * 'KernelId'<~String> - Id of kernel with which to launch
      #   * 'KeyName'<~String> - Name of a keypair to add to booting instances
      #   * 'Monitoring.Enabled'<~Boolean> - Enables monitoring, defaults to 
      #     disabled
      #   * 'RamdiskId'<~String> - Id of ramdisk with which to launch
      #   * 'UserData'<~String> -  Additional data to provide to booting instances
      #   * 'Version'<~String> - ?
      #   * 'VirtualName'<~String> - ?
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'groupSet'<~Array>: groups the instances are members in
      #       * 'groupName'<~String> - Name of group
      #     * 'instancesSet'<~Array>: returned instances
      #       * instance<~Hash>:
      #         * 'amiLaunchIndex'<~Integer> - reference to instance in launch group
      #         * 'dnsName'<~String> - public dns name, blank until instance is running
      #         * 'imageId'<~String> - image id of ami used to launch instance
      #         * 'instanceId'<~String> - id of the instance
      #         * 'instanceState'<~Hash>:
      #           * 'code'<~Integer> - current status code
      #           * 'name'<~String> - current status name
      #         * 'instanceType'<~String> - type of instance
      #         * 'kernelId'<~String> - Id of kernel used to launch instance
      #         * 'keyName'<~String> - name of key used launch instances or blank
      #         * 'launchTime'<~Time> - time instance was launched
      #         * 'monitoring'<~Hash>:
      #           * 'state'<~Boolean - state of monitoring
      #         * 'placement'<~Hash>:
      #           * 'availabilityZone'<~String> - Availability zone of the instance
      #         * 'privateDnsName'<~String> - private dns name, blank until instance is running
      #         * 'productCodes'<~Array> - Product codes for the instance
      #         * 'ramdiskId'<~String> - Id of ramdisk used to launch instance
      #         * 'reason'<~String> - reason for most recent state transition, or blank
      #     * 'ownerId'<~String> - Id of owner
      #     * 'requestId'<~String> - Id of request
      def run_instances(image_id, min_count, max_count, options = {})
        request({
          'Action' => 'RunInstances',
          'ImageId' => image_id,
          'MinCount' => min_count,
          'MaxCount' => max_count
        }.merge!(options), Fog::Parsers::AWS::EC2::RunInstances.new)
      end

    end
  end
end
