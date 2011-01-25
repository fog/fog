module Fog
  module Parsers
    module AWS
      module SES

        class SendEmail < Fog::Parsers::Base

          def reset
            @response = { 'SendEmailResult' => {}, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'MessageId'
              @response['SendEmailResult'][name] = @value
            when 'RequestId'
              @response['ResponseMetadata'][name] = @value
            end
          end

        end

      end
    end
  end
end
