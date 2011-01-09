module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetCatalogItem < Fog::Parsers::Base

          def reset
            @response = { 'properties' => [] }
          end

          def start_element(name, attrs = [])
            case name
            when 'CatalogItem'
              @response['name'] = attr_value('name', attrs)
              @response['uri']  = attr_value('href', attrs)
            when 'Link', 'Entity'
              href = attr_value('href', attrs)

              case attr_value('type', attrs)
              when 'application/vnd.tmrk.ecloud.catalogItemCustomizationParameters+xml'
                @response['customization_uri'] = href
              when 'application/vnd.vmware.vcloud.vAppTemplate+xml'
                @response['template_uri'] = href
              end
            when 'Property'
              @property_key = attr_value('key', attrs)
            end

            super
          end

          def end_element(name)
            case name
            when 'Property'
              @response['properties'].push({ 'key' => @property_key, 'value' => @value})
            end
          end
        end
      end
    end
  end
end
