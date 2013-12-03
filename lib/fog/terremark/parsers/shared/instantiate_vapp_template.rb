module Fog
  module Parsers
    module Terremark
      module Shared

        class InstantiateVappTemplate < TerremarkParser

          def reset
            @property_key
            @response = { 'Links' => [] }
          end

          def start_element(name, attributes)
            super
            case name
            when 'Link'
              link = extract_attributes(attributes)
              @response['Links'] << link
            when 'VApp'
              vapp_template = extract_attributes(attributes)
              @response.merge!(vapp_template.reject {|key, value| !['href', 'name', 'size', 'status', 'type'].include?(key)})
            end
          end

        end

      end
    end
  end
end
