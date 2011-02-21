module Fog
  module Parsers
    module Voxel
      module Compute
        class VoxcloudStatus < Fog::Parsers::Base
          def reset
            @response = { :stat => nil, :devices => [] }
            @device = {}
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'rsp'
              @response[:stat] = attr_value('stat', attrs)
            when 'err'
              @response[:error] = attr_value('msg', attrs)
            when 'device'
              @device = {}
            end
          end

          def end_element(name)
            case name
            when 'device'
              @response[:devices] << @device
              @device = {}
            when 'id'
              @device[:id] = @value
            when 'status'
              @device[:status] = @value
            end
          end
        end
      end
    end
  end
end
