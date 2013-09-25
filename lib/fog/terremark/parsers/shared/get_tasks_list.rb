module Fog
  module Parsers
    module Terremark
      module Shared

        class GetTasksList < TerremarkParser

          def reset
            @response = { 'Tasks' => [] }
            @task = {}
          end

          def start_element(name, attributes)
            super
            case name
            when 'Owner', 'Result'
              data = extract_templates(attributes)
              @task[name] = data
            when 'Task'
              @task = extract_templates(attributes)
            when 'TasksList'
              tasks_list = extract_templates(attributes)
              @response['href'] = tasks_list['href']
            end
          end

          def end_element(name)
            if name == 'Task'
              @response['Tasks'] << @task
              @task = {}
            end
          end

        end

      end
    end
  end
end
