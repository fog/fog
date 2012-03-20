module Fog
  module Parsers
    module Compute
      module AWS

        class CreateSecurityGroup < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'return'
              if value == 'true'
                @response[name] = true
              else
                @response[name] = false
              end
            when 'requestId', 'groupId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
