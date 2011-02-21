module Fog
  module Parsers
    module Voxel
      module Compute

        class VoxcloudCreate < Fog::Parsers::Base

          def reset
            @response = { :stat => nil, :device => {} }
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'rsp'
              @response[:stat] = attr_value('stat', attrs)
            end
          end

          def end_element(name)
            case name
            when 'id'
              @response[:device][:id] = @value
            end
          end

        end

      end
    end
  end
end
