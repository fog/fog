module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetVdc < Fog::Parsers::Base

          def reset
            @response = {
              'AvailableNetworks' => [],
              'ComputeCapacity'   => {
                'Cpu'                   => {},
                'DeployedVmsQuota'      => {},
                'InstantiatedVmsQuota'  => {},
                'Memory'                => {}
              },
              'Link'              => [],
              'ResourceEntities'  => [],
              'StorageCapacity'   => {}
            }
          end

          def start_element(name, attrs = [])
            case name
            when 'Cpu'
              @in_cpu = true
            when 'DeployedVmsQuota'
              @in_deployed_vms_quota = true
            when 'InstantiatedVmsQuota'
              @in_instantiated_vms_quota = true
            when 'Link'
              link = {}
              for attribute in %w{href name rel type}
                if value = attr_value(attribute, attrs)
                  link[attribute] = value
                end
              end
              @response['Link'] << link
            when 'Memory'
              @in_memory = true
            when 'Network'
              network = {}
              for attribute in %w{href name type}
                if value = attr_value(attribute, attrs)
                  network[attribute] = value
                end
              end
              @response['AvailableNetworks'] << network
            when 'StorageCapacity'
              @in_storage_capacity = true
            when 'ResourceEntity'
              resource_entity = {}
              for attribute in %w{href name type}
                if value = attr_value(attribute, attrs)
                  resource_entity[attribute] = value
                end
              end
              @response['ResourceEntities'] << resource_entity
            when 'Vdc'
              for attribute in %w{href name}
                if value = attr_value(attribute, attrs)
                  @response[attribute] = value
                end
              end
            end
            super
          end

          def end_element(name)
            case name
            when 'Description'
              @response[name] = @value
            when 'Allocated', 'Limit', 'Used'
              if @in_cpu
                @response['ComputeCapacity']['Cpu'][name] = @value.to_i
              elsif @in_deployed_vms_quota
                @response['ComputeCapacity']['DeployedVmsQuota'][name] = @value.to_i
              elsif @in_instantiated_vms_quota
                @response['ComputeCapacity']['InstantiatedVmsQuota'][name] = @value.to_i
              elsif @in_memory
                @response['ComputeCapacity']['Memory'][name] = @value.to_i
              elsif @in_storage_capacity
                @response['StorageCapacity'][name] = @value.to_i
              end
            when 'Cpu'
              @in_cpu = false
            when 'DeployedVmsQuota'
              @in_deployed_vms_quota = false
            when 'InstantiatedVmsQuota'
              @in_instantiated_vms_quota = false
            when 'Memory'
              @in_memory = false
            when 'StorageCapacity'
              @in_storage_capacity = false
            when 'Units'
              if @in_storage_capacity
                @response['StorageCapacity'][name] = @value
              elsif @in_cpu
                @response['ComputeCapacity']['Cpu'][name] = @value
              elsif @in_memory
                @response['ComputeCapacity']['Memory'][name] = @value
              end
            end
          end

        end
      end
    end
  end
end
