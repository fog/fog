module Fog
  module Parsers
    module Terremark
      module Shared

        class GetVappTemplate < TerremarkParser

          def reset
            @response = { 'Links' => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'Link'
              link = extract_attributes(attributes)
              @response['Links'] << link
            when 'VAppTemplate'
              vapp_template = extract_attributes(attributes)
              @response['name'] = vapp_template['name']
            end
          end

          def end_element(name)
            if name == 'Description'
              @response['Description'] = value
            end
          end

        end

      end
    end
  end
end
