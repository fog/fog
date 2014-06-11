module Fog
  module Parsers
    module Storage
      module InternetArchive
        class GetBucketLocation < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'LocationConstraint'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
