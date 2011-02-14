module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetIpAddress < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'Id', 'Href', 'Name', 'RnatAddress', 'Server', 'Status'
              @response[name] = @value
            end
          end

        end
      end
    end
  end
end
