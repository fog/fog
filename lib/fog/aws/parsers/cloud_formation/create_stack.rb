module Fog
  module Parsers
    module AWS
      module CloudFormation

        class CreateStack < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'StackId'
              @response[name] = @value
            end
          end

        end
      end
    end
  end
end
