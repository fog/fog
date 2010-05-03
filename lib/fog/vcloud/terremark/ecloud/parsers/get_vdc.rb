module Fog
  module Parsers
    module Vcloud
      module Terremark
        module Ecloud

          class GetVdc < Fog::Parsers::Vcloud::Base

            def reset
              @target = nil
              @response = Struct::TmrkEcloudVdc.new([],[],[],Struct::TmrkEcloudXCapacity.new,Struct::TmrkEcloudXCapacity.new,
                                                             Struct::TmrkEcloudXCapacity.new,Struct::TmrkEcloudXCapacity.new,
                                                             Struct::TmrkEcloudXCapacity.new)
            end

            def start_element(name, attributes)
              @value = ''
              case name
              when 'Cpu'
                @target = :cpu_capacity
              when 'DeployedVmsQuota'
                @target = :deployed_vm_quota
              when 'InstantiatedVmsQuota'
                @target = :instantiated_vm_quota
              when 'Memory'
                @target = :memory_capacity
              when 'StorageCapacity'
                @target = :storage_capacity
              when 'Link'
                @response.links << generate_link(attributes)
              when 'Network'
                @response.networks << generate_link(attributes)
              when 'ResourceEntity'
                @response.resource_entities << generate_link(attributes)
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
              when 'Cpu', 'DeployedVmsQuota', 'InstantiatedVmsQuota', 'Memory', 'StorageCapacity'
                @target = nil
              when 'Description'
                @response.description = @value
              end
            end

          end
        end
      end
    end
  end
end

