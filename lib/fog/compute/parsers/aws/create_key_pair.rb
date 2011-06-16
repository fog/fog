module Fog
  module Parsers
    module Compute
      module AWS

        class CreateKeyPair < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'keyFingerprint', 'keyMaterial', 'keyName', 'requestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
