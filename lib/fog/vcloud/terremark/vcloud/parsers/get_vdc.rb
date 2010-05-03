module Fog
  module Parsers
    module Vcloud
      module Terremark
        module Vcloud

          class GetVdc < Fog::Parsers::Vcloud::Base

            def reset
              @target = nil
              @response = Struct::TmrkVcloudVdc.new([],[],[])
            end

            def start_element(name, attributes)
              @value = ''
              case name
              when 'Link'
                @response.links << generate_link(attributes)
              when 'Network'
                @response.networks << generate_link(attributes)
              when 'ResourceEntity'
                @response.resource_entities << generate_link(attributes)
              when 'Vdc'
                handle_root(attributes)
              end
            end

          end
        end
      end
    end
  end
end

