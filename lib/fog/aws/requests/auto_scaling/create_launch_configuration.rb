module Fog
  module AWS
    class AutoScaling

      class Real

        require 'fog/aws/parsers/auto_scaling/basic'

        # Creates a new launch configuration. Once created, the new launch
        # configuration is available for immediate use.
        #
        # ==== Parameters
        # * image_id<~String> - Unique ID of the Amazon Machine Image (AMI)
        #   which was assigned during registration.
        # * instance_type<~String> - The instance type of the EC2 instance.
        # * launch_configuration_name<~String> - The name of the launch
        #   configuration to create.
        # * options<~Hash>:
        #   * 'BlockDeviceMappings'<~Array>:
        #     * 'DeviceName'<~String> - The name of the device within Amazon
        #       EC2.
        #     * 'Ebs.SnapshotId'<~String> - The snapshot ID.
        #     * 'Ebs.VolumeSize'<~Integer> - The volume size, in GigaBytes.
        #     * 'VirtualName'<~String> - The virtual name associated with the
        #       device.
        #   * 'InstanceMonitoring'<~Hash>:
        #     * 'Enabled'<~Boolean> - Enabled detailed monitoring.
        #   * 'KernelId'<~String> - The ID of the kernel associated with the
        #     EC2 AMI.
        #   * 'KeyName'<~String> - The name of the EC2 key pair.
        #   * 'RamdiskId'<~String> - The ID of the RAM disk associated with the
        #     EC2 AMI.
        #   * 'SecurityGroups'<~Array> - The names of the security groups with
        #     which to associate EC2 instances.
        #   * 'UserData'<~String> - User data available to the launched EC2
        #     instances.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_CreateLaunchConfiguration.html
        #
        def create_launch_configuration(image_id, instance_type, launch_configuration_name, options = {})
          if block_device_mappings = options.delete('BlockDeviceMappings')
            block_device_mappings.each_with_index do |mapping, i|
              for key, value in mapping
                options.merge!({ format("BlockDeviceMappings.member.%d.#{key}", i+1) => value })
              end
            end
          end
          if security_groups = options.delete('SecurityGroups')
             options.merge!(AWS.indexed_param('SecurityGroups.member.%d', [*security_groups]))
          end
          if options['UserData']
            options['UserData'] = Base64.encode64(options['UserData'])
          end
          request({
            'Action'                  => 'CreateLaunchConfiguration',
            'ImageId'                 => image_id,
            'InstanceType'            => instance_type,
            'LaunchConfigurationName' => launch_configuration_name,
            :parser                   => Fog::Parsers::AWS::AutoScaling::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def create_launch_configuration(image_id, instance_type, launch_configuration_name, options = {})
          if data[:launch_configurations].has_key?(launch_configuration_name)
            raise Fog::AWS::AutoScaling::IdentifierTaken.new("Launch Configuration by this name already exists - A launch configuration already exists with the name #{launch_configuration_name}")
          end
          data[:launch_configurations][launch_configuration_name] = {
            'BlockDeviceMappings'     => [],
            'CreatedTime'             => Time.now.utc,
            'ImageId'                 => image_id,
            'InstanceMonitoring'      => { 'Enabled' => true },
            'InstanceType'            => instance_type,
            'KernelId'                => nil,
            'KeyName'                 => nil,
            'LaunchConfigurationARN'  => "arn:aws:autoscaling:eu-west-1:000000000000:launchConfiguration:00000000-0000-0000-0000-000000000000:launchConfigurationName/#{launch_configuration_name}",
            'LaunchConfigurationName' => launch_configuration_name,
            'RamdiskId'               => nil,
            'SecurityGroups'          => [],
            'UserData'                => nil
          }.merge!(options)

          response = Excon::Response.new
          response.status = 200
          response.body = {
            'ResponseMetadata' => { 'RequestId' => Fog::AWS::Mock.request_id }
          }
          response
        end

      end

    end
  end
end
