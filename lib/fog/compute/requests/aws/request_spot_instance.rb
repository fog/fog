module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/request_spot_instance'

        # Creates a Spot Instance request
        #
        # ==== Parameters
        # * image_id<~String> - Id of machine image to load on instances
        # * max_price<~String> - The maximum hourly price 
        # * max_count<~Integer> -The maximium number of instances to launch
        # * options<~Hash>:
        #   * Type<~String> - request type ['one-time'|'persistent']
        #   * ValidFrom<>
        #   * ValidUntil<>
        #   * LaunchGroup<>
        #   * AvailabilityZoneGroup<>
        #   * LaunchSpecification<~Hash>
        #     * 'Placement.AvailabilityZone'<~String> - Placement constraint for instances
        #     * 'BlockDeviceMapping'<~Array>: array of hashes
        #       * 'DeviceName'<~String> - where the volume will be exposed to instance
        #       * 'VirtualName'<~String> - volume virtual device name
        #       * 'Ebs.SnapshotId'<~String> - id of snapshot to boot volume from
        #       * 'Ebs.VolumeSize'<~String> - size of volume in GiBs required unless snapshot is specified
        #       * 'Ebs.NoDevice'<~String> - specifies that no device should be mappped
        #       * 'Ebs.DeleteOnTermination'<~String> - specifies whether or not to delete the volume on instance termination
        #     * 'ClientToken'<~String> - unique case-sensitive token for ensuring idempotency
        #     * 'SecurityGroup'<~Array> or <~String> - Name of security group(s) for instances (you must omit this parameter if using Virtual Private Clouds)
        #     * 'InstanceInitiatedShutdownBehaviour'<~String> - specifies whether volumes are stopped or terminated when instance is shutdown, in [stop, terminate]
        #     * 'InstanceType'<~String> - Type of instance to boot. Valid options
        #        in ['m1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.xlarge', 'm2.2xlarge', 'm2.4xlarge', 't1.micro']
        #        default is 'm1.small'
        #     * 'KernelId'<~String> - Id of kernel with which to launch
        #     * 'KeyName'<~String> - Name of a keypair to add to booting instances
        #     * 'Monitoring.Enabled'<~Boolean> - Enables monitoring, defaults to
        #       disabled
        #     * 'RamdiskId'<~String> - Id of ramdisk with which to launch
        #     * 'UserData'<~String> -  Additional data to provide to booting instances
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'spotInstanceRequestSet'<~Array>: array of hashes
        #       * 'item'<~Hash>:
        #         * 'spotInstanceRequestId'<~String> - 
        #         * 'spotPrice
        #         * 'amiLaunchIndex'<~Integer> - reference to instance in launch group
        #         * 'architecture'<~String> - architecture of image in [i386, x86_64]
        #         * 'blockDeviceMapping'<~Array>
        #           * 'attachTime'<~Time> - time of volume attachment
        #           * 'deleteOnTermination'<~Boolean> - whether or not to delete volume on termination
        #           * 'deviceName'<~String> - specifies how volume is exposed to instance
        #           * 'status'<~String> - status of attached volume
        #           * 'volumeId'<~String> - Id of attached volume
        #         * 'dnsName'<~String> - public dns name, blank until instance is running
        #         * 'imageId'<~String> - image id of ami used to launch instance
        #         * 'instanceId'<~String> - id of the instance
        #         * 'instanceState'<~Hash>:
        #           * 'code'<~Integer> - current status code
        #           * 'name'<~String> - current status name
        #         * 'instanceType'<~String> - type of instance
        #         * 'ipAddress'<~String> - public ip address assigned to instance
        #         * 'kernelId'<~String> - Id of kernel used to launch instance
        #         * 'keyName'<~String> - name of key used launch instances or blank
        #         * 'launchTime'<~Time> - time instance was launched
        #         * 'monitoring'<~Hash>:
        #           * 'state'<~Boolean - state of monitoring
        #         * 'placement'<~Hash>:
        #           * 'availabilityZone'<~String> - Availability zone of the instance
        #         * 'privateDnsName'<~String> - private dns name, blank until instance is running
        #         * 'privateIpAddress'<~String> - private ip address assigned to instance
        #         * 'productCodes'<~Array> - Product codes for the instance
        #         * 'ramdiskId'<~String> - Id of ramdisk used to launch instance
        #         * 'reason'<~String> - reason for most recent state transition, or blank
        #         * 'rootDeviceName'<~String> - specifies how the root device is exposed to the instance
        #         * 'rootDeviceType'<~String> - root device type used by AMI in [ebs, instance-store]

        def request_spot_instance(image_id, max_price, max_count, options = {})
          launch_specification = options.delete('LaunchSpecification')
          if block_device_mapping = launch_specification.delete('BlockDeviceMapping')
            block_device_mapping.each_with_index do |mapping, index|
              for key, value in mapping
                launch_specification.merge!({ format("BlockDeviceMapping.%d.#{key}", index) => value })
              end
            end
          end
          if security_groups = launch_specification.delete('SecurityGroup')
            launch_specification.merge!(AWS.indexed_param('SecurityGroup', [*security_groups]))
          end
          if launch_specification['UserData']
            launch_specification['UserData'] = Base64.encode64(launch_specification['UserData'])
          end
          idempotent = !(launch_specification['ClientToken'].nil? || launch_specification['ClientToken'].empty?)
          request({
            'Action'                      => 'RequestSpotInstances',
            'SpotPrice'                   => max_price,
            'InstanceCount'               => max_count,
            'MinCount'                    => min_count,
            'LaunchSpecification.ImageId' => image_id,
            :idempotent                   => idempotent,
            :parser                       => Fog::Parsers::AWS::Compute::RunInstances.new
          }.merge!('LaunchSpecification' => launch_specification))

        end

      end

      class Mock

        def request_spot_instance(image_id, max_price, max_count, options = {})
          response = Excon::Response.new
          response.status = 200

          group_set = [ (options['
        end
      end
    end
  end
end
