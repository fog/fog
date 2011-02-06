module Fog
  module Parsers
    module AWS
      module SQS

        class ReceiveMessage < Fog::Parsers::Base

          def reset
            @response = { 'ResponseMetadata' => {}, 'Message' => {'Attributes' => {}}}
          end

          def end_element(name)
            case name
            when 'RequestId'
              @response['ResponseMetadata']['RequestId'] = @value
            when 'MessageId'
              @response['Message']['MessageId'] = @value
            when 'ReceiptHandle'
              @response['Message']['ReceiptHandle'] = @value
            when 'MD5OfBody'
              @response['Message']['MD5OfBody'] = @value
            when 'Body'
              @response['Message']['Body'] = @value
            when 'Name'
              @current_attribute_name = @value
            when 'Value'
              @response['Message']['Attributes'][@current_attribute_name] = @value
            end
          end

        end

      end
    end
  end
end
