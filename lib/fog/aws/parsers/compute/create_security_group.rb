module Fog
  module Parsers
    module Compute
      module AWS

        class CreateSecurityGroup < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId', 'return', 'groupId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
