module Fog
  module Parsers
    module Terremark

      class GetVappTemplate < Fog::Parsers::Base

        def reset
          @property_key
          @response = { 'Links' => [] }
        end

        def start_element(name, attributes)
          @value = ''
          case name
          when 'Link'
            link = {}
            until attributes.empty?
              link[attributes.shift] = attributes.shift
            end            
            @response['Links'] << link
          when 'VAppTemplate'
            vapp_template = {}
            until attributes.empty?
              if attributes.first.is_a?(Array)
                vapp_template[attributes.first.first] = attributes.shift.last
              else
                vapp_template[attributes.shift] = attributes.shift
              end
            end
            @response['name'] = vapp_template['name']
          end
        end

        def end_element(name)
          if name == 'Description'
            @response['Description'] = @value
          end
        end

      end

    end
  end
end
