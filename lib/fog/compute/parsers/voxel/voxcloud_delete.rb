module Fog
  module Parsers
    module Voxel
      module Compute

        class VoxcloudDelete < Fog::Parsers::Base

          def reset
            @response = { :stat => nil }
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'rsp'
              @response[:stat] = attr_value('stat', attrs)
            when 'err'
              @response[:error] = attr_value('msg', attrs)
            end
          end

        end

      end
    end
  end
end
