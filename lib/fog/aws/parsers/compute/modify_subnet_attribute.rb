module Fog
  module Parsers
    module Compute
      module AWS
        class ModifySubnetAttribute < Fog::Parsers::Base
          def reset
            @response = {  }
          end


          def end_element(name)
            case name
            when 'return'
              @response[name] = value == 'true' ? true : false
            when 'requestId'
              @response[name] = value
            end
          
          end
        end
      end
    end
  end
end
