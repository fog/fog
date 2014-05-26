module Fog
  module Parsers
    module Compute
      module AWS
        class CopyImage < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'imageId'
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
