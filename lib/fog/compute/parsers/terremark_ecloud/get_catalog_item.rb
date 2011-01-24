module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetCatalogItem < Fog::Parsers::Base

          def reset
            @response = { 'Entity' => {}, 'Link' => {}, 'Property' => {} }
          end

          def start_element(name, attrs = [])
            case name
            when 'CatalogItem'
              for attribute in %w{href type name}
                if value = attr_value(attribute, attrs)
                  @response[attribute] = value
                end
              end
            when 'Link', 'Entity'
              for attribute in %w{href name rel type}
                if value = attr_value(attribute, attrs)
                  @response[name][attribute] = value
                end
              end
            when 'Property'
              @property_key = attr_value('key', attrs)
            end

            super
          end

          def end_element(name)
            case name
            when 'Property'
              @response['Property'][@property_key] = @value
            end
          end
        end
      end
    end
  end
end
