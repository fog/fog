module Fog
  module Parsers
    module AWS
      module AutoScaling

        class DescribeLaunchConfigurations < Fog::Parsers::Base

          def reset
            reset_launch_configuration
            reset_block_device_mapping
            reset_ebs
            @results = { 'LaunchConfigurations' => [] }
            @response = { 'DescribeLaunchConfigurationsResult' => {}, 'ResponseMetadata' => {} }
          end

          def reset_launch_configuration
            @launch_configuration = { 'BlockDeviceMappings' => [], 'InstanceMonitoring' => {}, 'SecurityGroups' => [] }
          end

          def reset_block_device_mapping
            @block_device_mapping = {}
          end

          def reset_ebs
            @ebs = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'BlockDeviceMappings'
              @in_block_device_mappings = true
            when 'SecurityGroups'
              @in_security_groups = true
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_block_device_mappings
                @launch_configuration['BlockDeviceMappings'] << @block_device_mapping
                reset_block_device_mapping
              elsif @in_security_groups
                @launch_configuration['SecurityGroups'] << value
              else
                @results['LaunchConfigurations'] << @launch_configuration
                reset_launch_configuration
              end

            when 'DeviceName', 'VirtualName'
              @block_device_mapping[name] = value

            when 'SnapshotId', 'VolumeSize'
              @ebs[name] = value
            when 'Ebs'
              @block_device_mapping[name] = @ebs
              reset_ebs

            when 'Enabled'
              @launch_configuration['InstanceMonitoring'][name] = (value == 'true')

            when 'CreatedTime'
              @launch_configuration[name] = Time.parse(value)
            when 'ImageId', 'InstanceType', 'KeyName'
              @launch_configuration[name] = value
            when 'LaunchConfigurationARN', 'LaunchConfigurationName'
              @launch_configuration[name] = value
            when 'KernelId', 'RamdiskId', 'UserData'
              @launch_configuration[name] = value

            when 'BlockDeviceMappings'
              @in_block_device_mappings = false
            when 'LaunchConfigurations'
              @in_launch_configurations = false
            when 'SecurityGroups'
              @in_security_groups = false

            when 'NextToken'
              @results[name] = value

            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'DescribeLaunchConfigurationsResponse'
              @response['DescribeLaunchConfigurationsResult'] = @results
            end
          end

        end
      end
    end
  end
end
