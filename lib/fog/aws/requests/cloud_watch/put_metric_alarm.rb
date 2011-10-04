module Fog
  module AWS
    class CloudWatch
      class Real     

        require 'fog/aws/parsers/cloud_watch/put_metric_alarm'

        # Creates or updates an alarm and associates it with the specified Amazon CloudWatch metric
        # ==== Options
        # * ActionsEnabled<~Boolean>: Indicates whether or not actions should be executed during any changes to the alarm's state
        # * AlarmActions<~Array>: A list of actions to execute 
        # * AlarmDescription<~String>: The description for the alarm
        # * AlarmName<~String> The unique name for the alarm
        # * ComparisonOperator<~String>: The arithmetic operation to use for comparison
        # * Dimensions<~Array>: a list of dimensions to filter against,
        #     Name : The name of the dimension
        #     Value : The value to filter against
        # * EvaluationPeriods<~Integer>: The number of periods over which data is compared to the specified threshold
        # * InsufficientDataActions<~Array>: A list of actions to execute 
        # * MetricName<~String>: The name for the alarm's associated metric
        # * Namespace<~String>: The namespace for the alarm's associated metric
        # * OKActions<~Array>: A list of actions to execute 
        # * Period<~Integer>: The period in seconds over which the specified statistic is applied
        # * Statistic<~String>: The statistic to apply to the alarm's associated metric
        # * Threshold<~Double>: The value against which the specified statistic is compared
        # * Unit<~String>: The unit for the alarm's associated metric
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/API_PutMetricAlarm.html
        #

        def put_metric_alarm(options)
          if dimensions = options.delete('Dimensions')
            options.merge!(AWS.indexed_param('Dimensions.member.%d.Name', dimensions.collect {|dimension| dimension['Name']}))
            options.merge!(AWS.indexed_param('Dimensions.member.%d.Value', dimensions.collect {|dimension| dimension['Value']}))
          end
          if alarm_actions = options.delete('AlarmActions')
            options.merge!(AWS.indexed_param('AlarmActions.member.%d', [*alarm_actions]))
          end
          if insufficient_data_actions = options.delete('InsufficientDataActions')
            options.merge!(AWS.indexed_param('InsufficientDataActions.member.%d', [*insufficient_data_actions]))
          end
          if ok_actions = options.delete('OKActions')
            options.merge!(AWS.indexed_param('OKActions.member.%d', [*ok_actions]))
          end
          request({
              'Action'    => 'PutMetricAlarm',
              :parser     => Fog::Parsers::AWS::CloudWatch::PutMetricAlarm.new
            }.merge(options))
        end
      end       
    end
  end
end
