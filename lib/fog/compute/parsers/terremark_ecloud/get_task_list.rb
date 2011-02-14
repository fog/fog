module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetTaskList < Fog::Parsers::Base

          def reset
            @response = { 'Tasks' => [] }
            @task = {}
          end

          def start_element(name, attrs = [])
            case name
            when 'Task'
              for attribute in %w{href status type}
                if value = attr_value(attribute, attrs)
                  @task[attribute] = value
                end
              end
              for attribute in %w{endTime startTime}
                if value = attr_value(attribute, attrs)
                  @task[attribute] = Time.parse(value)
                end
              end
            when 'Owner', 'Result'
              data = {}
              for attribute in %w{href name type}
                if value = attr_value(attribute, attrs)
                  data[attribute] = value
                end
              end
              @task[name] = data
            end

            super
          end

          def end_element(name)
            case name
            when 'Task'
              @response['Tasks'] << @task
              @task = {}
            end
          end

        end
      end
    end
  end
end
