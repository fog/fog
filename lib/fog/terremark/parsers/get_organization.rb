module Fog
  module Parsers
    module Terremark

      class GetOrganization < Fog::Parsers::Base

        def reset
          @response = { 'links' => [] }
        end

        def start_element(name, attributes)
          @value = ''
          case name
          when 'Link'
            link = {}
            until attributes.empty?
              link[attributes.shift] = attributes.shift
            end            
            @response['links'] << link
          when 'Org'
            org = {}
            until attributes.empty?
              if attributes.first.is_a?(Array)
                org[attributes.first.first] = attributes.shift.last
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
            @response[name] = @value
          end
        end

      end

    end
  end
end
