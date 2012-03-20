module Fog
  module Parsers
    module Compute
      module AWS

        class CreateSecurityGroup < Fog::Parsers::Base

          def end_element(name)
            case name
<<<<<<< HEAD
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
=======
            when 'requestId', 'return', 'groupId'
              @response[name] = value
            end
          end

        end

>>>>>>> de807f03b1890ea0fe65f98852e607a0d284e762
      end
    end
  end
end
