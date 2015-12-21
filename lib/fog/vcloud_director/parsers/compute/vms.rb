module Fog
  module Parsers
    module Compute
      module VcloudDirector
        class Vms < VcloudDirectorParser
          def reset
            @vm = { :ip_address => '' }
            @in_operating_system = false
            @in_children = false
            @resource_type = nil
            @response = { :vms => [] }
            @links = []
          end

          def start_element(name, attributes)
            super
            case name
            when 'OperatingSystemSection'
              @in_operating_system = true
            when 'VApp'
              vapp = extract_attributes(attributes)
              @response.merge!(vapp.reject {|key,value| ![:href, :name, :size, :status, :type].include?(key)})
              @response[:id] = @response[:href].split('/').last
            when 'Vm'
              vapp = extract_attributes(attributes)
              @vm.merge!(vapp.reject {|key,value| ![:href, :name, :status, :type].include?(key)})
              @vm[:id] = @vm[:href].split('/').last
              @vm[:vapp_id] = @response[:id]
              @vm[:vapp_name] = @response[:name]
              @vm[:status] = human_status(@vm[:status])
            when 'Children'
              @in_children = true
            when 'HostResource'
              @current_host_resource = extract_attributes(attributes)
            when 'Link'
              @links << extract_attributes(attributes)
            end
          end

          def end_element(name)
            if @in_children
              case name
              when 'IpAddress'
                @vm[:ip_address] = value
              when 'Description'
                if !@vm[:description]
                  # Assume the first description we find is the VM description
                  @vm[:description] = value
                end
                if @in_operating_system
                  @vm[:operating_system] = value
                  @in_operating_system = false
                end
              when 'ResourceType'
                @resource_type = value
              when 'VirtualQuantity'
                case @resource_type
                when '3'
                  @vm[:cpu] = value
                when '4'
                  @vm[:memory] = value
                end
              when 'ElementName'
                @element_name = value
              when 'Item'
                if @resource_type == '17' # disk
                  @vm[:disks] ||= []
                  @vm[:disks] << { @element_name => @current_host_resource[:capacity].to_i }
                end
              when 'Link'
                @vm[:links] = @links
              when 'Vm'
                @response[:vms] << @vm
                @vm = {}
              end
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
