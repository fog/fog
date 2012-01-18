require 'fog/core/collection'
require 'fog/aws/models/cloud_watch/alarm'

module Fog
  module AWS
    class CloudWatch

      class Alarms < Fog::Collection
        model Fog::AWS::CloudWatch::Alarm
    
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
