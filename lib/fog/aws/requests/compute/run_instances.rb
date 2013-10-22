module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/run_instances'

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
        #   * 'Placement.GroupName'<~String> - Name of existing placement group to launch instance into
        #   * 'Placement.Tenancy'<~String> - Tenancy option in ['dedicated', 'default'], defaults to 'default'
        #   * 'BlockDeviceMapping'<~Array>: array of hashes
        #     * 'DeviceName'<~String> - where the volume will be exposed to instance
        #     * 'VirtualName'<~String> - volume virtual device name
        #     * 'Ebs.SnapshotId'<~String> - id of snapshot to boot volume from
        #     * 'Ebs.VolumeSize'<~String> - size of volume in GiBs required unless snapshot is specified
        #     * 'Ebs.DeleteOnTermination'<~String> - specifies whether or not to delete the volume on instance termination
        #     * 'Ebs.VolumeType'<~String> - Type of EBS volue. Valid options in ['standard', 'io1'] default is 'standard'.
        #     * 'Ebs.Iops'<~String> - The number of I/O operations per second (IOPS) that the volume supports. Required when VolumeType is 'io1'
        #   * 'ClientToken'<~String> - unique case-sensitive token for ensuring idempotency
        #   * 'DisableApiTermination'<~Boolean> - specifies whether or not to allow termination of the instance from the api
        #   * 'SecurityGroup'<~Array> or <~String> - Name of security group(s) for instances (not supported for VPC)
        #   * 'SecurityGroupId'<~Array> or <~String> - id's of security group(s) for instances, use this or SecurityGroup
        #   * 'InstanceInitiatedShutdownBehaviour'<~String> - specifies whether volumes are stopped or terminated when instance is shutdown, in [stop, terminate]
        #   * 'InstanceType'<~String> - Type of instance to boot. Valid options
        #     in ['t1.micro', 'm1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.xlarge', m2.2xlarge', 'm2.4xlarge', 'cc1.4xlarge', 'cc2.8xlarge', 'cg1.4xlarge']
        #     default is 'm1.small'
        #   * 'KernelId'<~String> - Id of kernel with which to launch
        #   * 'KeyName'<~String> - Name of a keypair to add to booting instances
        #   * 'Monitoring.Enabled'<~Boolean> - Enables monitoring, defaults to
        #     disabled
        #   * 'PrivateIpAddress<~String> - VPC option to specify ip address within subnet
        #   * 'RamdiskId'<~String> - Id of ramdisk with which to launch
        #   * 'SubnetId'<~String> - VPC option to specify subnet to launch instance into
        #   * 'UserData'<~String> -  Additional data to provide to booting instances
        #   * 'EbsOptimized'<~Boolean> - Whether the instance is optimized for EBS I/O
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'groupSet'<~Array>: groups the instances are members in
        #       * 'groupName'<~String> - Name of group
        #     * 'instancesSet'<~Array>: returned instances
        #       * instance<~Hash>:
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
        #         * 'ebsOptimized'<~Boolean> - Whether the instance is optimized for EBS I/O
        #     * 'ownerId'<~String> - Id of owner
        #     * 'requestId'<~String> - Id of request
        #     * 'reservationId'<~String> - Id of reservation
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-RunInstances.html]
        def run_instances(image_id, min_count, max_count, options = {})
          if block_device_mapping = options.delete('BlockDeviceMapping')
            block_device_mapping.each_with_index do |mapping, index|
              for key, value in mapping
                options.merge!({ format("BlockDeviceMapping.%d.#{key}", index) => value })
              end
            end
          end
          if security_groups = options.delete('SecurityGroup')
            options.merge!(Fog::AWS.indexed_param('SecurityGroup', [*security_groups]))
          end
          if security_group_ids = options.delete('SecurityGroupId')
            options.merge!(Fog::AWS.indexed_param('SecurityGroupId', [*security_group_ids]))
          end
          if options['UserData']
            options['UserData'] = Base64.encode64(options['UserData'])
          end

          idempotent = !(options['ClientToken'].nil? || options['ClientToken'].empty?)

          request({
            'Action'    => 'RunInstances',
            'ImageId'   => image_id,
            'MinCount'  => min_count,
            'MaxCount'  => max_count,
            :idempotent => idempotent,
            :parser     => Fog::Parsers::Compute::AWS::RunInstances.new
          }.merge!(options))
        end

      end

      class Mock

        def run_instances(image_id, min_count, max_count, options = {})
          response = Excon::Response.new
          response.status = 200

          group_set = [ (options['SecurityGroup'] || 'default') ].flatten
          instances_set = []
          reservation_id = Fog::AWS::Mock.reservation_id

          if options['KeyName'] && describe_key_pairs('key-name' => options['KeyName']).body['keySet'].empty?
            raise Fog::Compute::AWS::NotFound.new("The key pair '#{options['KeyName']}' does not exist")
          end

          min_count.times do |i|
            instance_id = Fog::AWS::Mock.instance_id
            instance = {
              'amiLaunchIndex'      => i,
              'associatePublicIP'   => options['associatePublicIP'] || false,
              'architecture'        => 'i386',
              'blockDeviceMapping'  => [],
              'clientToken'         => options['clientToken'],
              'dnsName'             => nil,
              'ebsOptimized'        => options['EbsOptimized'] || false,
              'hypervisor'          => 'xen',
              'imageId'             => image_id,
              'instanceId'          => instance_id,
              'instanceState'       => { 'code' => 0, 'name' => 'pending' },
              'instanceType'        => options['InstanceType'] || 'm1.small',
              'kernelId'            => options['KernelId'] || Fog::AWS::Mock.kernel_id,
              'keyName'             => options['KeyName'],
              'launchTime'          => Time.now,
              'monitoring'          => { 'state' => options['Monitoring.Enabled'] || false },
              'placement'           => { 'availabilityZone' => options['Placement.AvailabilityZone'] || Fog::AWS::Mock.availability_zone(@region), 'groupName' => nil, 'tenancy' => 'default' },
              'privateDnsName'      => nil,
              'productCodes'        => [],
              'reason'              => nil,
              'rootDeviceType'      => 'instance-store',
              'virtualizationType'  => 'paravirtual'
            }
            instances_set << instance
            self.data[:instances][instance_id] = instance.merge({
              'groupIds'            => [],
              'groupSet'            => group_set,
              'iamInstanceProfile'  => {},
              'networkInterfaces'   => [],
              'ownerId'             => self.data[:owner_id],
              'privateIpAddress'    => nil,
              'reservationId'       => reservation_id,
              'stateReason'         => {}
            })
          end
          response.body = {
            'groupSet'      => group_set,
            'instancesSet'  => instances_set,
            'ownerId'       => self.data[:owner_id],
            'requestId'     => Fog::AWS::Mock.request_id,
            'reservationId' => reservation_id
          }
          response
        end

      end
    end
  end
end
