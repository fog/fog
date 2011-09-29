module Fog
  module Parsers
    module AWS
      module CloudWatch
      
        class DescribeAlarms < Fog::Parsers::Base
        
          def reset
            @response = { 'DescribeAlarmsResult' => {'MetricAlarms' => []}, 'ResponseMetadata' => {} }
            reset_metric_alarms
          end

          def reset_metric_alarms
            @metric_alarms = {'Dimensions' => []}
          end
          
          def reset_dimension
            @dimension = {}
          end
          
          def start_element(name, attrs = [])
            super
            case name  
            when 'Dimensions'
              @in_dimensions = true
            when 'member'
              if @in_dimensions
                reset_dimension
              end
            end
          end

          def end_element(name)
            case name
            when 'Name', 'Value'
              @dimension[name] = value
            when 'AlarmConfigurationUpdatedTimestamp', 'StateUpdatedTimestamp'
              @metric_alarms[name] = Time.parse value
            when 'Period', 'EvaluationPeriods'
              @metric_alarms[name] = value.to_i
            when 'Threshold'
              @metric_alarms[name] = value.to_f
            when 'AlarmActions', 'OKActions', 'InsufficientDataActions'
              @metric_alarms[name] = value.to_s.strip
            when 'AlarmName', 'Namespace', 'MetricName', 'AlarmDescription', 'AlarmArn',
            	'StateValue', 'Statistic', 'ComparisonOperator', 'StateReason', 'ActionsEnabled'
              @metric_alarms[name] = value
            when 'Dimensions'
              @in_dimensions = false  
	    	when 'RequestId'
              @response['ResponseMetadata'][name] = value              
            when 'member'
              if !@in_dimensions
                unless @metric_alarms == {}
                  if @metric_alarms.has_key?('AlarmName')
            	    @response['DescribeAlarmsResult']['MetricAlarms']  << @metric_alarms
                  else 
                    @response['DescribeAlarmsResult']['MetricAlarms'].last.merge!( @metric_alarms)
                    reset_metric_alarms
                  end
                end
              else
                @metric_alarms['Dimensions'] << @dimension
              end
            end
          end
        end
      end
    end
  end
end