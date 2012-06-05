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
            when 'UserName', 'PolicyName'
              @response[name] = value
            when 'PolicyDocument'
              @response[name] = if decoded_string = URI.decode(value)
                                  Fog::JSON.decode(decoded_string) rescue value
                                else
                                  value
                                end
            when 'RequestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
