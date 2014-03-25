module Fog
  module Parsers
    module DNS
      module AWS

        class GetChange < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'Id'
              @response[name] = value.sub('/change/', '')
            when 'Status', 'SubmittedAt'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
