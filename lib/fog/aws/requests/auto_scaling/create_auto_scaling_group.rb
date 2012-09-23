module Fog
  module AWS
    class AutoScaling

      class Real

        require 'fog/aws/parsers/auto_scaling/basic'

        # Creates a new Auto Scaling group with the specified name. Once the
        # creation request is completed, the AutoScalingGroup is ready to be
        # used in other calls.
        #
        # ==== Parameters
        # * auto_scaling_group_name<~String> - The name of the Auto Scaling
        #   group.
        # * availability_zones<~Array> - A list of availability zones for the
        #   Auto Scaling group.
        # * launch_configuration_name<~String> - The name of the launch
        #   configuration to use with the Auto Scaling group.
        # * max_size<~Integer> - The maximum size of the Auto Scaling group.
        # * min_size<~Integer> - The minimum size of the Auto Scaling group.
        # * options<~Hash>:
        #   * 'DefaultCooldown'<~Integer> - The amount of time, in seconds,
        #     after a scaling activity completes before any further trigger-
        #     related scaling activities can start.
        #   * 'DesiredCapacity'<~Integer> - The number of Amazon EC2 instances
        #     that should be running in the group.
        #   * 'HealthCheckGracePeriod'<~Integer> - Length of time in seconds
        #     after a new Amazon EC2 instance comes into service that Auto
        #     Scaling starts checking its health.
        #   * 'HealthCheckType'<~String> - The service you want the health
        #     status from, Amazon EC2 or Elastic Load Balancer. Valid values
        #     are "EC2" or "ELB".
        #   * 'LoadBalancerNames'<~Array> - A list of LoadBalancers to use.
        #   * 'PlacementGroup'<~String> - Physical location of your cluster
        #      placement group created in Amazon EC2.
        #   * 'TerminationPolicies'<~Array> - A standalone termination policy
        #     or a list of termination policies used to select the instance to
        #     terminate. The policies are executed in the order that they are
        #     listed.
        #   * 'VPCZoneIdentifier'<~String> - A comma-separated list of subnet
        #     identifiers of Amazon Virtual Private Clouds (Amazon VPCs).
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_CreateAutoScalingGroup.html
        #
        def create_auto_scaling_group(auto_scaling_group_name, availability_zones, launch_configuration_name, max_size, min_size, options = {})
          options.merge!(AWS.indexed_param('AvailabilityZones.member.%d', [*availability_zones]))
          options.delete('AvailabilityZones')
          if load_balancer_names = options.delete('LoadBalancerNames')
            options.merge!(AWS.indexed_param('LoadBalancerNames.member.%d', [*load_balancer_names]))
          end
          if tags = options.delete('Tags')
            tags.each_with_index do |tag, i|
              tag.each do |key, value|
                options["Tags.member.#{i + 1}.#{key.to_s.capitalize}"] = value
              end
            end
          end
          if termination_policies = options.delete('TerminationPolicies')
            options.merge!(AWS.indexed_param('TerminationPolicies.member.%d', [*termination_policies]))
          end
          request({
            'Action'                  => 'CreateAutoScalingGroup',
            'AutoScalingGroupName'    => auto_scaling_group_name,
            'LaunchConfigurationName' => launch_configuration_name,
            'MaxSize'                 => max_size,
            'MinSize'                 => min_size,
            :parser                   => Fog::Parsers::AWS::AutoScaling::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def create_auto_scaling_group(auto_scaling_group_name, availability_zones, launch_configuration_name, max_size, min_size, options = {})
          if data[:auto_scaling_groups].has_key?(auto_scaling_group_name)
            raise Fog::AWS::AutoScaling::IdentifierTaken.new("AutoScalingGroup by this name already exists - A group with the name #{auto_scaling_group_name} already exists")
          end
          unless data[:launch_configurations].has_key?(launch_configuration_name)
            raise Fog::AWS::AutoScaling::ValidationError.new('Launch configuration name not found - null')
          end
          data[:auto_scaling_groups][auto_scaling_group_name] = {
            'AutoScalingGroupARN'     => "arn:aws:autoscaling:eu-west-1:000000000000:autoScalingGroup:00000000-0000-0000-0000-000000000000:autoScalingGroupName/#{auto_scaling_group_name}",
            'AutoScalingGroupName'    => launch_configuration_name,
            'AvailabilityZones'       => availability_zones.to_a,
            'CreatedTime'             => Time.now.utc,
            'DefaultCooldown'         => 300,
            'DesiredCapacity'         => 0,
            'EnabledMetrics'          => [],
            'HealthCheckGracePeriod'  => 0,
            'HealthCheckType'         => 'EC2',
            'Instances'               => [],
            'LaunchConfigurationName' => launch_configuration_name,
            'LoadBalancerNames'       => [],
            'MaxSize'                 => max_size,
            'MinSize'                 => min_size,
            'PlacementGroup'          => nil,
            'SuspendedProcesses'      => [],
            'Tags'                    => [],
            'TerminationPolicies'     => ['Default'],
            'VPCZoneIdentifier'       => nil
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
