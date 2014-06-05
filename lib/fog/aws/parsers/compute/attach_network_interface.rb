module Fog
  module Parsers
    module Compute
      module AWS
        class AttachNetworkInterface < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'requestId', 'attachmentId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
