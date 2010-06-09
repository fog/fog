module Fog
  module Parsers
    module Vcloud

      class GetVdc < Fog::Parsers::Vcloud::Base
        #WARNING: Incomplete
        #Based off of:
        #vCloud API Guide v0.9 - Page 27

        def reset
          @target = nil
          @response = Struct::VcloudVdc.new([],[],[],Struct::VcloudXCapacity.new,Struct::VcloudXCapacity.new,Struct::VcloudXCapacity.new)
        end

        def start_element(name, attributes=[])
          super
          case name
          when 'Cpu'
            @target = :cpu_capacity
          when 'Memory'
            @target = :memory_capacity
          when 'StorageCapacity'
            @target = :storage_capacity
          when 'NetworkQuota'
            @target = :network_quota
          when 'VmQuota'
            @target = :vm_quota
          when 'NicQuota'
            @target = :nic_quota
          when 'Link'
            @response.links << generate_link(attributes)
          when 'ResourceEntity'
            @response.resource_entities << generate_link(attributes)
          when 'Network'
            @response.networks << generate_link(attributes)
          when 'Vdc'
            handle_root(attributes)
          end
        end

        def end_element(name)
          case name
          when 'Allocated', 'Limit', 'Used'
            @response[@target][name.downcase] = @value.to_i
          when 'Units'
            @response[@target][name.downcase] = @value
          when "AllocationModel"
            @response.allocation_model = @value
          when "Description"
            @response.description = @value
          when "NicQuota", "VmQuota", "NetworkQuota"
            @response[@target] = @value.to_i
          when 'IsEnabled'
            @response.enabled = (@value == 'true' ? true : false)
          end
        end

      end

    end
  end
end
