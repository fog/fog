module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetVdc < Fog::Parsers::Base

          def reset
            @response = {
              'storageCapacity' => {}, 'cpuCapacity' => {},
              'memoryCapacity' => {}, 'networks' => [], 'vms' => []
            }
          end

          def start_element(name, attrs = [])
            case name
            when 'Vdc'
              @response['name'] = attr_value('name', attrs)
              @response['uri']  = attr_value('href', attrs)
            when 'Link'
              href = attr_value('href', attrs)

              case attr_value('type', attrs)
              when 'application/vnd.vmware.vcloud.catalog+xml'
                @response['catalog_uri'] = href
              when 'application/vnd.tmrk.ecloud.publicIpsList+xml'
                @response['publicIpsList_uri'] = href
              when 'application/vnd.tmrk.ecloud.internetServicesList+xml'
                @response['internetServicesList_uri'] = href
              when 'application/vnd.tmrk.ecloud.firewallAclsList+xml'
                @response['firewallAclsList_uri'] = href
              when 'application/vnd.tmrk.ecloud.networkGroupList+xml'
                @response['trustedNetworkGroupsList_uri'] = href
              end
            when 'StorageCapacity'
              @in_storage_capacity = true
            when 'ComputeCapacity'
              @in_compute_capacity = true
            when 'Cpu'
              @in_compute_capacity && @in_cpu_capacity = true
            when 'Memory'
              @in_compute_capacity && @in_memory_capacity = true
            when 'ResourceEntities'
              @in_resource_entities = true
            when 'ResourceEntity'
              if @in_resource_entities
                @response['vms'].push({
                                        'name' => attr_value('name', attrs),
                                        'uri'  => attr_value('href', attrs)
                                      })
              end
            when 'AvailableNetworks'
              @in_available_networks = true
            when 'Network'
              if @in_available_networks
                @response['networks'].push({
                                             'name' => attr_value('name', attrs),
                                             'uri'  => attr_value('href', attrs)
                                           })
              end
            end

            super
          end

          def end_element(name)
            case name
            when 'Allocated', 'Used'
              if @in_storage_capacity
                @response['storageCapacity'][name.downcase] = @value.to_i
              elsif @in_cpu_capacity
                @response['cpuCapacity'][name.downcase] = @value.to_i
              elsif @in_memory_capacity
                @response['memoryCapacity'][name.downcase] = @value.to_i
              end
            when 'StorageCapacity'
              @in_storage_capacity = false
            when 'ComputeCapacity'
              @in_compute_capacity = false
            when 'Cpu'
              @in_compute_capacity && @in_cpu_capacity = false
            when 'Memory'
              @in_compute_capacity && @in_memory_capacity = false
            when 'ResourceEntities'
              @in_resource_entities = false
            when 'AvailableNetworks'
              @in_available_networks = false
            end
          end

        end
      end
    end
  end
end
