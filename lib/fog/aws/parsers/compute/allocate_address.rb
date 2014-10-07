module Fog
  module Parsers
    module Compute
      module AWS
        class AllocateAddress < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'publicIp', 'requestId', 'domain', 'allocationId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
