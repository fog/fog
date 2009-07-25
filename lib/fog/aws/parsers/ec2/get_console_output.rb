module Fog
  module Parsers
    module AWS
      module EC2

        class GetConsoleOutput < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'instanceId'
              @response[:instance_id] = @value
            when 'output'
              @response[:output] = Base64.decode64(@value)
            when 'requestId'
              @response[:request_id] = @value
            when 'timestamp'
              @response[:timestamp] = Time.parse(@value)
            end
          end

        end

      end
    end
  end
end