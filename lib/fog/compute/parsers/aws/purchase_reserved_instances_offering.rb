module Fog
  module Parsers
    module Compute
      module AWS

        class PurchaseReservedInstancesOffering < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'reservedInstancesId', 'requestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
