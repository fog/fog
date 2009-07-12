module Fog
  module Parsers
    module AWS
      module EC2

        class Basic < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId'
              @response[:request_id] = @value
            when 'return'
              if @value == 'true'
                @response[:return] = true
              else
                @response[:return] = false
              end
            end
          end

        end
      end
    end
  end
end
