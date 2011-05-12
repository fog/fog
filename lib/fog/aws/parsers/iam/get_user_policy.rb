module Fog
  module Parsers
    module AWS
      module IAM

        class GetUserPolicy < Fog::Parsers::Base
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_GetUserPolicy.html

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'UserName', 'PolicyName', 'PolicyDocument'
              @response[name] = value
            when 'RequestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
