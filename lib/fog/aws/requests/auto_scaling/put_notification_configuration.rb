module Fog
  module AWS
    class AutoScaling

      class Real

        require 'fog/aws/parsers/auto_scaling/put_notification_configuration'

        # Creates a notification configuration for an Auto Scaling group. To update an
        # existing policy, overwrite the existing notification configuration name 
        # and set the parameter(s) you want to change. 
        #
        # ==== Parameters
        # * auto_scaling_group_name<~String> - The name of the Auto Scaling group.
        # * notification_types<~Array> - The type of events that will trigger the 
        #   notification.
        # * topic_arn<~String> - The Amazon Resource Name (ARN) of the Amazon 
        #   Simple Notification Service (SNS) topic.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_PutNotificationConfiguration.html
        #
        def put_notification_configuration(auto_scaling_group_name, notification_types, topic_arn)
          options = {}
          options.merge!(AWS.indexed_param('NotificationTypes.member.%d', [*notification_types]))
          request({
            'Action'               => 'PutNotificationConfiguration',
            'AutoScalingGroupName' => auto_scaling_group_name,
            'TopicARN'             => topic_arn,
            :parser                => Fog::Parsers::AWS::AutoScaling::PutNotificationConfiguration.new
          }.merge!(options))
        end

      end

      class Mock

        def put_notification_configuration(auto_scaling_group_name, notification_types, topic_arn)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
