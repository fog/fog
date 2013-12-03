module Fog
  module Parsers
    module Terremark
      module Shared

        class Task < TerremarkParser

          def reset
            @response = {}
          end

          def start_element(name, attributes)
            super
            case name
            when 'Owner', 'Result', 'Link', 'Error'
              data = extract_attributes(attributes)
              @response[name] = data
            when 'Task'
              task = extract_attributes(attributes)
              @response.merge!(task.reject {|key,value| !['endTime', 'href', 'startTime', 'status', 'type'].include?(key)})
            end
          end

        end

      end
    end
  end
end
