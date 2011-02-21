module Fog
  module Parsers
    module Voxel
      module Compute

        class ImagesList < Fog::Parsers::Base

          def reset
            @image = {}
            @response = { :stat => nil, :images => [] }
          end

          def start_element(name, attrs = [])
            case name
            when 'image'
              @image = {
                :id => attr_value('id', attrs),
                :name => attr_value('summary', attrs)
              }
            when 'rsp'
              @response[:stat] = attr_value('stat', attrs)
            end
          end

          def end_element(name)
            case name
            when 'image'
              @response[:images] << @image
              @image = {}
            end
          end

        end

      end
    end
  end
end
