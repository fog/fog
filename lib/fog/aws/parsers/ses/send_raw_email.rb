module Fog
  module Parsers
    module AWS
      module SES

        class SendRawEmail < Fog::Parsers::Base

          def reset
            @response = { 'SendRawEmailResult' => {}, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'MessageId'
              @response['SendRawEmailResult'][name] = @value
            when 'RequestId'
              @response['ResponseMetadata'][name] = @value
            end
          end

        end

      end
    end
  end
end
