module Fog
  module Parsers
    module Compute
      module Vcloudng



        class Vm < VcloudngParser

          def reset
            @vm = {}
            @in_operating_system = false
            @in_children = false
            @resource_type = nil
            @response = { 'vms' => [] }
          end

          def start_element(name, attributes)
            super
            case name
              when 'OperatingSystemSection'
                @in_operating_system = true
             when 'VApp'
                vapp = extract_attributes(attributes)
                @response.merge!(vapp.reject {|key,value| !['href', 'name', 'size', 'status', 'type'].include?(key)})
                @response['id'] = @response['href'].split('/').last
              when 'Vm'
                 vapp = extract_attributes(attributes)
                 @vm.merge!(vapp.reject {|key,value| !['href', 'name', 'status', 'type'].include?(key)})
                 @vm['id'] = @vm['href'].split('/').last
                 @vm['vapp_id'] = @response['id']
                 @vm['status'] = human_status(@vm['status'])
             when 'Children'
               @in_children = true
             end
          end

          def end_element(name)
            if @in_children
              case name
              when 'IpAddress'
                @vm['ip_address'] = value
              when 'Description'
                if @in_operating_system
                  @vm['operating_system'] = value
                  @in_operating_system = false
                end
              when 'ResourceType'
                @resource_type = value
                case value
                when '3'
                  @get_cpu = true # cpu
                when '4'  # memory
                  @get_memory = true
                when '17' # disks
                  @get_disks = true
                end
              when 'VirtualQuantity'
                case @resource_type
                when '3'
                  @vm['cpu'] = value
                when '4'
                  @vm['memory'] = value
                when '17'
                  @vm['disks'] ||= []
                  @vm['disks'] << value
                end
              when 'Vm'
                @response['vms'] << @vm
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
