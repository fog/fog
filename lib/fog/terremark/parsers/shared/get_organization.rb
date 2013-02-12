module Fog
  module Parsers
    module Terremark
      module Shared

        class GetOrganization < TerremarkParser
          # include Fog::Terremark::Shared::Parser

          def reset
            @response = { 'Links' => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'Link'
              link = extract_attributes(attributes)
              until attributes.empty?
                if attributes.first.is_a?(Array)
                  attribute = attributes.shift
                  link[attribute.first] = attribute.last
                else
                  link[attributes.shift] = attributes.shift
                end
              end
              @response['Links'] << link
            when 'Org'
              org = extract_attributes(attributes)
              until attributes.empty?
                if attributes.first.is_a?(Array)
                  attribute = attributes.shift
                  org[attribute.first] = attribute.last
                else
                  org[attributes.shift] = attributes.shift
                end
              end
              @response['href'] = org['href']
              @response['name'] = org['name']
            end
          end

          def end_element(name)
            if name == 'Description'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
