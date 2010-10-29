module Fog
  module Parsers
    module AWS
      module IAM

        class Basic < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId'
              @response[name] = @value
            end
          end

        end
      end
    end
  end
end
