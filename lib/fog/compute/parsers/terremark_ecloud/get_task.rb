module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetTask < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def start_element(name, attrs = [])
            case name
            when 'Task'
              for attribute in %w{href status type}
                if value = attr_value(attribute, attrs)
                  @response[attribute] = value
                end
              end
              for attribute in %w{endTime startTime}
                if value = attr_value(attribute, attrs)
                  @response[attribute] = Time.parse(value)
                end
              end
            when 'Owner', 'Result'
              data = {}
              for attribute in %w{href name type}
                if value = attr_value(attribute, attrs)
                  data[attribute] = value
                end
              end
              @response[name] = data
            end

            super
          end

        end
      end
    end
  end
end
