module Fog
  module AWS
    class CloudWatch
      class Real     
      
      	require 'fog/aws/parsers/cloud_watch/enable_alarm_actions'
      
    	# Enables actions for the specified alarms
        # StartTime is capped to 2 weeks ago
        # ==== Options
        # * AlarmNames<~Array>: The names of the alarms to enable actions for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/API_EnableAlarmActions.html
        #
      
      
        def enable_alarm_actions(alarms)
          options = {}
          options.merge!(AWS.indexed_param('AlarmNames.member.%d', [*alarms]))
          request({
              'Action'    => 'EnableAlarmActions',
              :parser     => Fog::Parsers::AWS::CloudWatch::EnableAlarmActions.new
            }.merge(options))
        end
      end     
    end
  end
end

