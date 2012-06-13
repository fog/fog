module Fog
  module AWS
    class AutoScaling

      class Real

        require 'fog/aws/parsers/auto_scaling/basic'

        # Deletes notifications created by put_notification_configuration.
        #
        # ==== Parameters
        # * auto_scaling_group_name<~String> - The name of the Auto Scaling
        #   group.
        # * topic_arn<~String> - The Amazon Resource Name (ARN) of the Amazon Simple Notification Service (SNS) topic
        #   you wish to delete.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AutoScaling/latest/APIReference/API_DeleteNotificationConfiguration.html
        #
        def delete_notification_configuration(auto_scaling_group_name, topic_arn)
          request({
            'Action'               => 'DeleteNotificationConfiguration',
            'AutoScalingGroupName' => auto_scaling_group_name,
            'TopicARN'           => topic_arn,
            :parser                => Fog::Parsers::AWS::AutoScaling::Basic.new
          })
        end

      end

      class Mock

        def delete_notification_configuration(auto_scaling_group_name, topic_arn)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
