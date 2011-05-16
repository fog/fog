module Fog
  module Parsers
    module AWS
      module CloudWatch

        class ListMetrics < Fog::Parsers::Base

          def reset
            @response = { 'ListMetricsResult' => {'Metrics' => []}, 'ResponseMetadata' => {} }
            reset_metric
          end

          def reset_metric
            @metric = {'Dimensions' => []}
          end
          
          def reset_dimension
            @dimension = {}
          end
          
          def start_element(name, attrs = [])
            super
            case name  
            when 'Dimension'
              reset_dimension
            end
          end
          
          def end_element(name)
            case name  
            when 'Name'
              @dimension['Name'] = @value
            when 'Value'
              @dimension['Value'] = @value
            when 'Namespace'
              @metric['Namespace'] = @value
            when 'MetricName'
              @metric['MetricName'] = @value              
            when 'Dimension'
              @metric['Dimensions'] << @dimension
            when 'Metric'
              @response['ListMetricsResult']['Metrics'] << @metric
              reset_metric
            when 'NextMarker'
              @response['ListMetricsResult'][name] = @value
            when 'RequestId'
              @response['ResponseMetadata'][name] = @value
            end
          end
        end
      end
    end
  end
end
