module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetOrganization < Fog::Parsers::Base

          def reset
            @response = { 'Link' => [] }
          end

          def start_element(name, attrs = [])
            case name
            when 'Link'
              link = {}
              for attribute in %w{href name rel type}
                if value = attr_value(attribute, attrs)
                  link[attribute] = value
                end
              end
              @response['Link'] << link
            when 'Org'
              for attribute in %w{href name}
                if value = attr_value(attribute, attrs)
                  @response[attribute] = value
                end
              end
            end
          end

        end
      end
    end
  end
end
