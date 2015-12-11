module Fog
  module Parsers
    module Compute
      module VcloudDirector
        class Vm < VcloudDirectorParser
          def reset
            @in_operating_system = false
            @in_children = false
            @resource_type = nil
            @response = { :vm => { :ip_address => '' } }
            @links = []
          end

          def start_element(name, attributes)
            super
            case name
            when 'OperatingSystemSection'
              @in_operating_system = true
            when 'Vm'
              vm_attrs = extract_attributes(attributes)
              @response[:vm].merge!(vm_attrs.reject {|key,value| ![:href, :name, :status, :type].include?(key)})
              @response[:vm][:id] = @response[:vm][:href].split('/').last
              @response[:vm][:status] = human_status(@response[:vm][:status])
            when 'HostResource'
              @current_host_resource = extract_attributes(attributes)
            when 'Link'
              @links << extract_attributes(attributes)
            end
          end

          def end_element(name)
            case name
            when 'IpAddress'
              @response[:vm][:ip_address] = value
            when 'Description'
              # Assume the very first Description we find is the VM description
              if !@response[:vm][:description]
                @response[:vm][:description] = value
              end
              if @in_operating_system
                @response[:vm][:operating_system] = value
                @in_operating_system = false
              end
            when 'ResourceType'
              @resource_type = value
            when 'VirtualQuantity'
              case @resource_type
              when '3'
                @response[:vm][:cpu] = value
              when '4'
                @response[:vm][:memory] = value
              end
            when 'ElementName'
              @element_name = value
            when 'Item'
              if @resource_type == '17' # disk
                @response[:vm][:disks] ||= []
                @response[:vm][:disks] << { @element_name => @current_host_resource[:capacity].to_i }
              end
            when 'Link'
              @response[:vm][:links] = @links
            end
          end

          def human_status(status)
            case status
            when '0', 0
              'creating'
            when '8', 8
              'off'
            when '4', 4
              'on'
            else
              'unknown'
            end
          end
        end
      end
    end
  end
end
