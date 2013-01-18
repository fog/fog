module Fog
  module Parsers
    module Compute
      module AWS

        class AssociateAddress < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId', 'associationId'
              @response[name] = value
            when 'return'
              if value == 'true'
                @response[name] = true
              else
                @response[name] = false
              end
            end
          end

        end
      end
    end
  end
end
