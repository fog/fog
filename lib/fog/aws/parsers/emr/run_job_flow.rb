module Fog
  module Parsers
    module AWS
      module EMR

        class RunJobFlow < Fog::Parsers::Base

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'JobFlowId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
