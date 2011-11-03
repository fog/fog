module Fog
  module Parsers
    module AWS
      module VPC

        class DeleteVpc < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'return', 'requestId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end

