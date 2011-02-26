module Fog
  module Parsers
    module AWS
      module CloudFormation

        class GetTemplate < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'TemplateBody'
              @response[name] = @value
            end
          end

        end
      end
    end
  end
end
