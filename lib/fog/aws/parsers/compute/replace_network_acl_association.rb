module Fog
  module Parsers
    module Compute
      module AWS
        class ReplaceNetworkAclAssociation < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'requestId', 'newAssociationId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
