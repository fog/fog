module Fog
  module Parsers
    module AWS
      module S3

        class GetRequestPayment < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'Payer'
              @response[name] = @value
            end
          end

        end

      end
    end
  end
end
