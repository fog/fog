module Fog
  module Parsers
    module AWS
      module IAM

        class CreateAccessKey < Fog::Parsers::Base

          def reset
            @response = { 'AccessKey' => {} }
          end

          def end_element(name)
            case name
            when 'AccessKey', 'UserName', 'SecretAccessKey', 'Status'
              @response['User'][name] = @value
            when 'RequestId'
              @response[name] = @value
            end
          end

        end

      end
    end
  end
end