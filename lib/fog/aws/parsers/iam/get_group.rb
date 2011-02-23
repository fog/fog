module Fog
  module Parsers
    module AWS
      module IAM

        class GetGroup < Fog::Parsers::Base
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/index.html?API_GetGroup.html

          def reset
            @user = {}
            @response = { 'Group' => {}, 'Users' => [] }
          end

          def end_element(name)
            case name
            when 'GroupName', 'GroupId', 'Arn'
              @response['Group'][name] = @value
            when 'UserId', 'UserName', 'Path', 'Arn'
              @user[name] = @value
            when 'member'
              @response['Users'] << @user              
              @user = {}
            when 'IsTruncated'	
              response[name] = (@value == 'true')
            when 'Marker', 'RequestId'              
              @response[name] = @value
            end
          end

        end

      end
    end
  end
end
