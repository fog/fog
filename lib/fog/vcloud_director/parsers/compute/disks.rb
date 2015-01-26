module Fog
  module Parsers
    module Compute
      module VcloudDirector
        class Disks < VcloudDirectorParser
          def reset
            @disk = {}
            @response = { :disks => [] }
            @host_resource = nil
          end

          def start_element(name, attributes)
            super
            case name
            when 'HostResource'
              @host_resource = extract_attributes(attributes)
            end
          end

          def end_element(name)
            case name
            when 'Address'
              @disk[:address] = value.to_i
            when 'AddressOnParent'
              @disk[:address_on_parent] = value.to_i
            when 'Description'
              @disk[:description] = value
            when 'ElementName'
              @disk[:name] = value
            when 'InstanceID'
              @disk[:id] = value.to_i
            when 'ResourceSubType'
              @disk[:resource_sub_type] = value
            when 'Parent'
              @disk[:parent] = value.to_i
            when 'ResourceType'
              @disk[:resource_type] = value.to_i
            when 'Item'
              if @host_resource
                @disk[:capacity] = @host_resource[:capacity].to_i
                @disk[:bus_sub_type] = @host_resource[:busSubType]
                @disk[:bus_type] = @host_resource[:busType].to_i
              end
              @response[:disks] << @disk
              @host_resource = nil
              @disk = {}
            end
          end
        end
      end
    end
  end
end
