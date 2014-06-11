require 'fog/vcloud_director/parsers/compute/vm_parser_helper'

module Fog
  module Parsers
    module Compute
      module VcloudDirector
        class Vm < VcloudDirectorParser
          include VmParserHelper

          def reset
            @in_operating_system = false
            @in_children = false
            @resource_type = nil
            @response = { :vm => { :ip_address => '' } }
            @links = []
          end

          def start_element(name, attributes)
            super
            if name == 'Vm'
              vm_attrs = extract_attributes(attributes)
              @response[:vm].merge!(vm_attrs.reject {|key,value| ![:href, :name, :status, :type, :deployed].include?(key)})
              @response[:vm][:id] = @response[:vm][:href].split('/').last
              @response[:vm][:status] = human_status(@response[:vm][:status])
              @response[:vm][:deployed] = @response[:vm][:deployed] == 'true'
            else
              parse_start_element name, attributes, @response[:vm]
            end
          end

          def end_element(name)
            parse_end_element name, @response[:vm]
            case name
            when 'IpAddress'
              @response[:vm][:ip_address] = value
            when 'Description'
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
              case @resource_type
              when '17' # disk
                @response[:vm][:disks] ||= []
                @response[:vm][:disks] << { @element_name => @current_host_resource[:capacity].to_i }
              when '10' # nic
                @response[:vm][:network_adapters] ||= []
                @response[:vm][:network_adapters] << {
                  :ip_address => @current_network_connection[:ipAddress],
                  :primary => (@current_network_connection[:primaryNetworkConnection] == 'true'),
                  :ip_allocation_mode => @current_network_connection[:ipAddressingMode]
                }
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
