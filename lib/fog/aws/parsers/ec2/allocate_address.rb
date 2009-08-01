module Fog
  module Parsers
    module AWS
      module EC2

        class AllocateAddress < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'publicIp', 'requestId'
              @response[name] = @value
            end
          end

        end
      end
    end
  end
end
