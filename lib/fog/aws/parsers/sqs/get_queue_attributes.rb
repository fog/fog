module Fog
  module Parsers
    module AWS
      module SQS

        class GetQueueAttributes < Fog::Parsers::Base

          def reset
            @response = { 'ResponseMetadata' => {}, 'Attributes' => {}}
          end

          def end_element(name)
            case name
            when 'RequestId'
              @response['ResponseMetadata']['RequestId'] = @value
            when 'Name'
              @current_attribute_name = @value
            when 'Value'
              @response['Attributes'][@current_attribute_name] = @value
            end
          end

        end

      end
    end
  end
end
