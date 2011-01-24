module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class Login < Fog::Parsers::Base

          def reset
            @response = { 'OrgList' => [] }
          end

          def start_element(name, attrs = [])
            case name
            when 'Org'
              @response['OrgList'] << {
                'href'  => attr_value('href', attrs),
                'name'  => attr_value('name', attrs),
                'type'  => attr_value('type', attrs)
              }
            end
          end

        end
      end
    end
  end
end
