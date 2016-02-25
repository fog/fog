module Fog
  module Parsers
    module Compute
      module VcloudDirector
        module VmParserHelper

          def parse_end_element(name, vm)
            case name
            when 'IpAddress'
              vm[:ip_address] = value
            when 'Description'
              if @in_operating_system
                vm[:operating_system] = value
                @in_operating_system = false
              end
            when 'ResourceType'
              @resource_type = value
            when 'VirtualQuantity'
              case @resource_type
              when '3'
                vm[:cpu] = value
              when '4'
                vm[:memory] = value
              end
            when 'ElementName'
              @element_name = value
            when 'Item'
              if @resource_type == '17' # disk
                vm[:disks] ||= []
                vm[:disks] << { @element_name => @current_host_resource[:capacity].to_i }
              end
            when 'Connection'
              vm[:network_adapters] ||= []
              vm[:network_adapters] << {
                :ip_address => @current_network_connection[:ipAddress],
                :primary => (@current_network_connection[:primaryNetworkConnection] == 'true'),
                :ip_allocation_mode => @current_network_connection[:ipAddressingMode],
                :network => value
              }
            when 'Link'
              vm[:links] = @links
            end
          end

          def parse_start_element(name, attributes, vm)
            case name
            when 'OperatingSystemSection'
              @in_operating_system = true
            when 'HostResource'
              @current_host_resource = extract_attributes(attributes)
            when 'Connection'
              @current_network_connection = extract_attributes(attributes)
            when 'Link'
              @links << extract_attributes(attributes)
            end
          end

        end
      end
    end
  end
end
