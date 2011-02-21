module Fog
  module Parsers
    module Voxel
      module Compute

        class DevicesList < Fog::Parsers::Base

          def reset
            @device = {}
            @response = { :stat => nil, :devices => [] }
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'device'
              @device = {
                :id => attr_value('id', attrs).to_i,
                :name => attr_value('label', attrs)
              }
            when 'type'
              @device[:type] = attr_value('id', attrs)
            when 'rsp'
              @response[:stat] = attr_value('stat', attrs)
            when 'ipassignment'
              @device[:addresses] ||= {}
              @current_type = attr_value('type', attrs).to_sym
              @device[:addresses][@current_type] = [] 
            end
          end

          def end_element(name)
            case name
            when 'device'
              @response[:devices] << @device
              @device = {}
            when 'cores'
              @device[:processing_cores] = @value 
            when 'ipassignment'
              @device[:addresses][@current_type] << @value
            end
          end

        end

      end
    end
  end
end
