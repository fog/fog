module Fog
  module AWS
    class AutoScaling

      class Real

        require 'fog/aws/parsers/auto_scaling/basic'

        # Creates a scheduled scaling action for a Auto Scaling group. If you
        # leave a parameter unspecified, the corresponding value remains
        # unchanged in the affected Auto Scaling group.
        #
        # ==== Parameters
        # * auto_scaling_group_name<~String> - The name or ARN of the Auto
        #   Scaling Group.
        # * scheduled_action_name<~String> - Name of this scaling action.
        # * time<~Datetime> - The time for this action to start
        # * options<~Hash>:
        #   * 'DesiredCapacity'<~Integer> - The number of EC2 instances that
        #     should be running in this group.
        #   * 'MaxSize'<~Integer> - The maximum size for the Auto Scaling
        #     group.
        #   * 'MinSize'<~Integer> - The minimum size for the Auto Scaling
        #     group.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_PutScheduledUpdateGroupAction.html
        #
        def put_scheduled_update_group_action(auto_scaling_group_name, scheduled_action_name, time, options = {})
          request({
            'Action'               => 'PutScheduledUpdateGroupAction',
            'AutoScalingGroupName' => auto_scaling_group_name,
            'ScheduledActionName'  => scheduled_action_name,
            'Time'                 => time.utc.strftime('%FT%T.%3NZ'),
            :parser                => Fog::Parsers::AWS::AutoScaling::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def put_scheduled_update_group_action(auto_scaling_group_name, scheduled_policy_name, time, options = {})
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
