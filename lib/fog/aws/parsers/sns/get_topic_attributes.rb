module Fog
  module Parsers
    module AWS
      module SNS

        class GetTopicAttributes < Fog::Parsers::Base

          def reset
            @response = { 'Attributes' => {} }
          end

          def end_element(name)
            case name
            when "key"
              @key = @value
            when "value"
              @response['Attributes'][@key] = @value
            when 'RequestId'
              @response[name] = @value
            end
          end
        end

      end
    end
  end
end
