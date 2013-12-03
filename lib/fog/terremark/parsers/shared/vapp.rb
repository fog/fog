module Fog
  module Parsers
    module Terremark
      module Shared

        class Vapp < TerremarkParser

          def reset
            @response = { 'Links' => [], 'VirtualHardware' => {}, 'OperatingSystem' => {} }
            @in_operating_system = false
            @resource_type = nil
          end

          def start_element(name, attributes)
            super
            case name
              when 'Link'
                link = extract_attributes(attributes)
                @response['Links'] << link
              when 'OperatingSystemSection'
                @in_operating_system = true
             when 'VApp'
                vapp = extract_attributes(attributes)
                @response.merge!(vapp.reject {|key,value| !['href', 'name', 'size', 'status', 'type'].include?(key)})
             end
          end

          def end_element(name)
            case name
            when 'IpAddress'
              @response['IpAddress'] = value
            when 'Description'
              if @in_operating_system
                @response['OperatingSystem'][name] = value
                @in_operating_system = false
              end
            when 'ResourceType'
              @resource_type = value
              case value
              when '3'
                @get_cpu = true # cpu
              when '4'  # memory
                @get_ram = true
              when '17' # disks
                @get_disks = true
              end
            when 'VirtualQuantity'
              case @resource_type
              when '3'
                @response['VirtualHardware']['cpu'] = value
              when '4'
                @response['VirtualHardware']['ram'] = value
              when '17'
                @response['VirtualHardware']['disks'] ||= []
                @response['VirtualHardware']['disks'] << value
              end
            end
          end

        end

      end
    end
  end
end

