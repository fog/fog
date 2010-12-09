module Fog
  module Parsers
    module Terremark
      module Shared

        class GetOrganizations < Fog::Parsers::Base

          def reset
            @response = { 'OrgList' => [] }
          end

          def start_element(name, attributes)
            super
            if name == 'Org'
              organization = {}
              until attributes.empty?
                if attributes.first.is_a?(Array)
                  attribute = attributes.shift
                  organization[attribute.first] = attribute.last
                else
                  organization[attributes.shift] = attributes.shift
                end
              end
              @response['OrgList'] << organization
            end
          end

        end
      end
    end
  end
end
