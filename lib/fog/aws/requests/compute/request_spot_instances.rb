module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/spot_instance_requests'

        # Launch specified instances
        #
        # ==== Parameters
        # * 'image_id'<~String> - Id of machine image to load on instances
        # * 'instance_type'<~String> - Type of instance
        # * 'spot_price'<~Float> - maximum hourly price for instances launched
        # * options<~Hash>:
        #   * 'AvailabilityZoneGroup'<~String> - specify whether or not to launch all instances in the same availability group
        #   * 'InstanceCount'<~Integer> - maximum number of instances to launch
        #   * 'LaunchGroup'<~String> - whether or not to launch/shutdown instances as a group
        #   * 'LaunchSpecification.BlockDeviceMapping'<~Array>: array of hashes
        #     * 'DeviceName'<~String> - where the volume will be exposed to instance
        #     * 'VirtualName'<~String> - volume virtual device name
        #     * 'Ebs.SnapshotId'<~String> - id of snapshot to boot volume from
        #     * 'Ebs.NoDevice'<~String> - specifies that no device should be mapped
        #     * 'Ebs.VolumeSize'<~String> - size of volume in GiBs required unless snapshot is specified
        #     * 'Ebs.DeleteOnTermination'<~String> - specifies whether or not to delete the volume on instance termination
        #   * 'LaunchSpecification.KeyName'<~String> - Name of a keypair to add to booting instances
        #   * 'LaunchSpecification.Monitoring.Enabled'<~Boolean> - Enables monitoring, defaults to disabled
        #   * 'LaunchSpecification.Placement.AvailabilityZone'<~String> - Placement constraint for instances
        #   * 'LaunchSpecification.SecurityGroup'<~Array> or <~String> - Name of security group(s) for instances, not supported in VPC
        #   * 'LaunchSpecification.SecurityGroupId'<~Array> or <~String> - Id of security group(s) for instances, use this or LaunchSpecification.SecurityGroup
        #   * 'LaunchSpecification.UserData'<~String> -  Additional data to provide to booting instances
        #   * 'Type'<~String> - spot instance request type in ['one-time', 'persistent']
        #   * 'ValidFrom'<~Time> - start date for request
        #   * 'ValidUntil'<~Time> - end date for request
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
        #       * 'productDescription'<~String> - general description of AMI
        #       * 'spotInstanceRequestId'<~String> - id of spot instance request
        #       * 'spotPrice'<~Float> - maximum price for instances to be launched
        #       * 'state'<~String> - spot instance request state
        #       * 'type'<~String> - spot instance request type
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-RequestSpotInstances.html]
        def request_spot_instances(image_id, instance_type, spot_price, options = {})
          if block_device_mapping = options.delete('LaunchSpecification.BlockDeviceMapping')
            block_device_mapping.each_with_index do |mapping, index|
              for key, value in mapping
                options.merge!({ format("LaunchSpecification.BlockDeviceMapping.%d.#{key}", index) => value })
              end
            end
          end
          if security_groups = options.delete('LaunchSpecification.SecurityGroup')
            options.merge!(Fog::AWS.indexed_param('LaunchSpecification.SecurityGroup', [*security_groups]))
          end
          if security_group_ids = options.delete('LaunchSpecification.SecurityGroupId')
            options.merge!(Fog::AWS.indexed_param('LaunchSpecification.SecurityGroupId', [*security_group_ids]))
          end
          if options['LaunchSpecification.UserData']
            options['LaunchSpecification.UserData'] = Base64.encode64(options['LaunchSpecification.UserData'])
          end

          request({
            'Action'                            => 'RequestSpotInstances',
            'LaunchSpecification.ImageId'       => image_id,
            'LaunchSpecification.InstanceType'  => instance_type,
            'SpotPrice'                         => spot_price,
            :parser                             => Fog::Parsers::Compute::AWS::SpotInstanceRequests.new
          }.merge!(options))
        end

      end
    end
  end
end
