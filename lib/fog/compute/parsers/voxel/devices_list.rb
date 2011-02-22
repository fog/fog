module Fog
  module Parsers
    module Voxel
      module Compute

        class DevicesList < Fog::Parsers::Base

          def reset
            @device          = {}
            @response        = { :stat => nil, :devices => [] }
            @in_accessmethod = false
            @in_storage      = false
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
            when "facility"
              @device[:facility] = attr_value('code', attrs)
            when "storage"
              @in_storage = true
            when "accessmethod"
              if attr_value('type', attrs) == "admin"
                @in_accessmethod = true
              end
            end
          end

          def end_element(name)
            case name
            when 'device'
              @response[:devices] << @device
              @device = {}
            when 'cores'
              @device[:processing_cores] = @value.to_i
            when 'ipassignment'
              @device[:addresses][@current_type] << @value
            when "size"
              if @in_storage
                @device[:disk_size] = @value.to_i
                @in_storage = false
              end
            when "password"
              if @in_accessmethod
                @device[:password] = @value
                @in_accessmethod = false
              end
            end
          end

        end

      end
    end
  end
end
