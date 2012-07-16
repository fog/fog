require 'fog/core/collection'
require 'fog/aws/models/cloud_watch/alarm'

module Fog
  module AWS
    class CloudWatch

      class Alarms < Fog::Collection
        model Fog::AWS::CloudWatch::Alarm

        def all
          data = []
          next_token = nil
          loop do
            result = connection.describe_alarms('NextToken' => next_token).body['DescribeAlarmsResult']
            data += result['MetricAlarms']
            next_token = result['NextToken']
            break if next_token.nil?
          end
          load(data)
        end

        def get(identity)
          data = connection.describe_alarms('AlarmNames' => identity).body['DescribeAlarmsResult']['MetricAlarms'].first
          new(data) unless data.nil?
        end

        #alarm_names is an array of alarm names
        def delete(alarm_names)
          connection.delete_alarms(alarm_names)
          true
        end

        def disable(alarm_names)
          connection.disable_alarm_actions(alarm_names)
          true
        end

        def enable(alarm_names)
          connection.enable_alarm_actions(alarm_names)
          true
        end

      end
    end
  end
end
