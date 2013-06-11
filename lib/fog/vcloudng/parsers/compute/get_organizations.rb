module Fog
  module Parsers
    module Vcloudng
      module Compute

        class GetOrganizations < VcloudngParser

          def reset
            @response = { 'OrgList' => [] }
          end

          def start_element(name, attributes)
            super
            if name == 'Org'
              organization = extract_attributes(attributes)
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
