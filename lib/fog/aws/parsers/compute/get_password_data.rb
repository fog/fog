module Fog
  module Parsers
    module Compute
      module AWS
        class GetPasswordData < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'instanceId', 'requestId', 'passwordData'
              @response[name] = @value
            when 'timestamp'
              @response[name] = Time.parse(@value)
            end
          end
        end
      end
    end
  end
end
