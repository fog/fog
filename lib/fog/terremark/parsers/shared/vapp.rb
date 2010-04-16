module Fog
  module Parsers
    module Terremark
      module Shared

        class Vapp < Fog::Parsers::Base

          def reset
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
              when 'Vapp'
                vapp = {}
                until attributes.empty?
                  if attributes.first.is_a?(Array)
                    attribute = attributes.shift
                    vapp[attribute.first] = attribute.last
                  else
                    vapp[attributes.shift] = attributes.shift
                  end
                end
                @response.merge!(vapp.reject {|key,value| !['href', 'name', 'size', 'status', 'type'].include?(key)})
            end
          end

          def end_element(name)
            case name
            when 'IpAddress'
              @response['IpAddress'] = @value
            end
          end

        end

      end
    end
  end
end
