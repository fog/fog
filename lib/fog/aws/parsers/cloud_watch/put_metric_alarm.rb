module Fog
  module Parsers
    module AWS
      module CloudWatch

        class PutMetricAlarm < Fog::Parsers::Base

          def reset
            @response = { 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
<<<<<<< HEAD
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end       
=======
            when /RequestId|PutMetricAlarmResponse/
              @response['ResponseMetadata'][name] = @value.strip
            end
          end
        end
>>>>>>> [aws|cloudwatch] Add support for put-metric-alarm call.
      end
    end
  end
end
