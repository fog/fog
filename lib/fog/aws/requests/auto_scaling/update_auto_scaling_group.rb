module Fog
  module AWS
    class AutoScaling

      class Real

        require 'fog/aws/parsers/auto_scaling/basic'

        # Updates the configuration for the specified AutoScalingGroup.
        #
        # The new settings are registered upon the completion of this call. Any
        # launch configuration settings take effect on any triggers after this
        # call returns. Triggers that are currently in progress aren't
        # affected.
        #
        # ==== Parameters
        # * auto_scaling_group_name<~String> - The name of the Auto Scaling
        #   group.
        # * options<~Hash>:
        #   * 'AvailabilityZones'<~Array>: Availability zones for the group
        #   * 'DefaultCooldown'<~Integer> - Amount of time, in seconds, after a
        #     scaling activity completes before any further trigger-related
        #     scaling activities can start
        #   * 'DesiredCapacity'<~Integer> - Desired capacity for the scaling group
        #   * 'HealthCheckGracePeriod'<~Integer> - Length of time that Auto
        #      Scaling waits before checking an instance's health status
        #   * 'HealthCheckType'<~String> - Service of interest for the health
        #     status check, either "EC2" or "ELB".
        #   * 'LaunchConfigurationName'<~String> - Name of the launch configuration
        #   * 'MaxSize'<~Integer> - Maximum size of the Auto Scaling group
        #   * 'MinSize'<~Integer> - Minimum size of the Auto Scaling group
        #   * 'PlacementGroup'<~String> - Name of the cluster placement group,
        #     if applicable
        #   * 'VPCZoneIdentifier'<~String> - Identifier for the VPC connection,
        #     if applicable
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_UpdateAutoScalingGroup.html
        #
        def update_auto_scaling_group(auto_scaling_group_name, options = {})
          if availability_zones = options.delete('AvailabilityZones')
            options.merge!(AWS.indexed_param('AvailabilityZones.member.%d', [*availability_zones]))
          end
          request({
            'Action'               => 'UpdateAutoScalingGroup',
            'AutoScalingGroupName' => auto_scaling_group_name,
            :parser                => Fog::Parsers::AWS::AutoScaling::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def update_auto_scaling_group(auto_scaling_group_name, options = {})
          unless data[:auto_scaling_groups].has_key?(auto_scaling_group_name)
            raise Fog::AWS::AutoScaling::ValidationError.new('AutoScalingGroup name not found - null')
          end
          data[:auto_scaling_group_name][auto_scaling_group_name].merge!(options)

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
