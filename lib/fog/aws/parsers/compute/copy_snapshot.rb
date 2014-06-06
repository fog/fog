module Fog
  module Parsers
    module Compute
      module AWS
        class CopySnapshot < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'snapshotId'
              @response[name] = value
            when 'requestId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
