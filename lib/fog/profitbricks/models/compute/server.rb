require 'fog/compute/models/server'

module Fog
    module Compute
        class ProfitBricks
            class Server < Fog::Compute::Server
                identity  :id,                  :aliases => 'serverId'
                attribute :name,                :aliases => 'serverName'
                attribute :cores
                attribute :ram
                attribute :attached_volumes,    :aliases => 'connectedStorages'
                attribute :interfaces,          :aliases => 'nics'
                attribute :internet_access,     :aliases => 'internetAccess'
                attribute :zone,                :aliases => 'availabilityZone'
                attribute :creation_time,       :aliases => 'creationTime'
                attribute :modification_time,   :aliases => 'lastModificationTime'
                attribute :machine_state,       :aliases => 'virtualMachineState'
                attribute :state,               :aliases => 'provisioningState'
                attribute :os_type,             :aliases => 'osType'
                attribute :cpu_hotplug,         :aliases => 'cpuHotPlug'
                attribute :ram_hotplug,         :aliases => 'ramHotPlug'
                attribute :nic_hotplug,         :aliases => 'nicHotPlug'
                attribute :nic_hotunplug,       :aliases => 'nicHotUnPlug'
                attribute :disc_hotplug,        :aliases => 'discVirtioHotPlug'
                attribute :disc_hotunplug,      :aliases => 'discVirtioHotUnPlug'
                attribute :data_center_id,      :aliases => 'dataCenterId'
                attribute :data_center_version, :aliases => 'dataCenterVersion'
                attribute :request_id,          :aliases => 'requestId'

                attr_accessor :options
                attr_accessor :flavor_id

                def initialize(attributes={})
                    super
                end

                def save
                    requires :data_center_id

                    if (cores and ram)
                        data = service.create_server(data_center_id, cores, ram, options || {})
                    elsif flavor_id
                        flavor = service.flavors.get(flavor_id)
                        data = service.create_server(data_center_id, flavor.cores, flavor.ram, options || {})
                    else
                        raise ArgumentError, 'cores/ram or flavor_id is required for this operation'
                    end

                    merge_attributes(data.body['createServerResponse'])
                    true
                end

                def update
                    requires :id

                    data = service.update_server(id, options)
                    merge_attributes(data.body['updateServerResponse'])
                    true
                end

                def reset
                    requires :id
                    service.reset_server(id)
                    true
                end

                def start
                    requires :id
                    service.start_server(id)
                    true
                end

                def stop
                    requires :id
                    service.stop_server(id)
                    true
                end

                def destroy
                    requires :id
                    service.delete_server(id)
                    true
                end

                def volumes
                    service.volumes.find_all do |volume|
                        volume.server_ids =~ /#{id}/
                    end
                end

                def interfaces
                    service.interfaces.find_all do |nic|
                        nic.server_id == id
                    end
                end

                def ready?
                    self.state == 'AVAILABLE'
                end

                def failed?
                    self.state == 'ERROR'
                end
            end
        end
    end
end
