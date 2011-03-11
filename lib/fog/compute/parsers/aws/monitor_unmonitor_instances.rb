module Fog
  module Parsers
    module AWS
      module Compute

        class MonitorUnmonitorInstances < Fog::Parsers::Base

          def reset
            @response = {}
            @current_id = nil
          end

          def end_element(name)
            case name
            when 'instanceId'
              @current_id = @value
            when 'item'
              @current_id = nil
            when 'state'
              @response[@current_id] = @value
            end
          end

        end

      end
    end
  end
end
