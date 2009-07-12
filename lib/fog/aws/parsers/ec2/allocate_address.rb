module Fog
  module Parsers
    module AWS
      module EC2

        class AllocateAddress < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId'
              @response[:request_id] = @value
            when 'publicIp'
              @response[:public_ip] = @value
            end
          end

        end
      end
    end
  end
end
