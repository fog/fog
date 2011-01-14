module Fog
  module Parsers
    module AWS
      module SNS

        class ListTopics < Fog::Parsers::Base

          def reset
            @user = {}
            @response = { 'Topics' => [] }
          end

          def end_element(name)
            case name
            when 'TopicARN'
              @response['Topics'] << @user
              @user = {}
            when 'NextToken', 'RequestId'
              response[name] = @value
            end
          end

        end

      end
    end
  end
end
