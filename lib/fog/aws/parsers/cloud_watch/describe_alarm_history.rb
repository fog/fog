module Fog
  module Parsers
    module AWS
      module CloudWatch

        class DescribeAlarmHistory < Fog::Parsers::Base

          def reset
            @response = { 'DescribeAlarmHistoryResult' => {'AlarmHistory' => []}, 'ResponseMetadata' => {} }
            reset_alarm_history
          end

          def reset_alarm_history
            @alarm_history = {}
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'AlarmName', 'HistoryItemType', 'HistorySummary'
              @alarm_history[name] = value
            when 'Timestamp'
              @alarm_history[name] = Time.parse value 
            when 'RequestId'
              @response['ResponseMetadata'][name] = value              
            when 'member'
              @response['DescribeAlarmHistoryResult']['AlarmHistory']  << @alarm_history
              reset_alarm_history
            end
          end
        end
      end
    end
  end
end