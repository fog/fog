module Fog
  module Parsers
    module AWS
      module CloudWatch
      
        class DescribeAlarmsForMetric < Fog::Parsers::Base
        
          def reset
            @response = { 'DescribeAlarmsForMetricResult' => {'AlarmsForMetric' => []}, 'ResponseMetadata' => {} }
            reset_alarms_for_metric
          end

          def reset_alarms_for_metric
            @alarms_for_metric = {'Dimensions' => []}
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
            when 'Period', 'EvaluationPeriods'
              @alarms_for_metric[name] = value.to_i
            when 'Threshold'
              @alarms_for_metric[name] = value.to_f
            when 'AlarmActions', 'OKActions', 'InsufficientDataActions'
              @alarms_for_metric[name] = value.to_s.strip
            when 'AlarmName', 'Namespace', 'MetricName', 'AlarmDescription', 'AlarmArn',
                'StateValue', 'Statistic', 'ComparisonOperator', 'StateReason', 'ActionsEnabled'
        	  @alarms_for_metric[name] = value
            when 'Dimensions'
              @in_dimensions = false  
	    	when 'RequestId'
              @response['ResponseMetadata'][name] = value              
            when 'member'
              if !@in_dimensions
                @response['DescribeAlarmsForMetricResult']['AlarmsForMetric']  << @alarms_for_metric
                reset_alarms_for_metric
              else
                @alarms_for_metric['Dimensions'] << @dimension
              end 
            end
          end
        end
      end
    end
  end
end