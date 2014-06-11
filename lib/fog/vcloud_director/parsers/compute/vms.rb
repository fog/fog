require 'fog/vcloud_director/parsers/compute/vm_parser_helper'

module Fog
  module Parsers
    module Compute
      module VcloudDirector
        class Vms < VcloudDirectorParser
          include VmParserHelper

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
            when 'Vm'
              vapp = extract_attributes(attributes)
              @vm.merge!(vapp.reject {|key,value| ![:href, :name, :status, :type, :deployed].include?(key)})
              @vm[:deployed] = response[:deployed] == 'true'
              @vm[:id] = @vm[:href].split('/').last
              @vm[:vapp_id] = @response[:id]
              @vm[:vapp_name] = @response[:name]
              @vm[:status] = human_status(@vm[:status])
            when 'VApp'
              vapp = extract_attributes(attributes)
              @response.merge!(vapp.reject {|key,value| ![:href, :name, :size, :status, :type].include?(key)})
              @response[:id] = @response[:href].split('/').last
            when 'Children'
              @in_children = true
            else
              parse_start_element name, attributes, @vm
            end
          end

          def end_element(name)
            if @in_children
              if name == 'Vm'
                @response[:vms] << @vm
                @vm = {}
              else
                parse_end_element name, @vm
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
