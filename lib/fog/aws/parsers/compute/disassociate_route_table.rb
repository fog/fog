module Fog
  module Parsers
    module Compute
      module AWS

        class DisassociateRouteTable < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId', 'return'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
