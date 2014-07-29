require 'fog/compute/models/server'

module Fog
    module Compute
        class ProfitBricks
            class Server < Fog::Compute::Server
                identity  :id,                 :aliases => 'serverId'
                attribute :name,               :aliases => 'serverName'
                attribute :cores
                attribute :ram
                attribute :boot_storage_id,    :aliases => 'bootFromStorageId'
                attribute :boot_image_id,      :aliases => 'bootFromImageId'
                attribute :internet_access,    :aliases => 'internetAccess'
                attribute :lan_id,             :aliases => 'lanId'
                attribute :os_type,            :aliases => 'osType'
                attribute :zone,               :aliases => 'availabilityZone'
                attribute :creation_time,      :aliases => 'creationTime'
                attribute :modification_time,  :aliases => 'lastModificationTime'
                attribute :machine_state,      :aliases => 'virtualMachineState'
                attribute :provisioning_state, :aliases => 'provisioningState'

                def save
                    requires :data_center_id, :cores, :ram

                    options = {
                        'serverName'        => name,
                        'bootFromStorageId' => boot_storage_id,
                        'bootFromImageId'   => boot_image_id,
                        'internetAccess'    => internet_access,
                        'lanId'             => lan_id,
                        'osType'            => os_type,
                        'availabilityZone'  => zone,
                    }

                    data = service.create_server(
                        data_center_id, cores, ram, options
                    )
                    merge_attributes(data.body['createServerResponse'])
                    true
                end 

                def update
                    requires :id

                    options = {
                        'cores'             => cores,
                        'ram'               => ram,
                        'serverName'        => name,
                        'bootFromStorageId' => boot_storage_id,
                        'bootFromImageId'   => boot_image_id,
                        'internetAccess'    => internet_access,
                        'lanId'             => lan_id,
                        'osType'            => os_type,
                        'availabilityZone'  => zone,
                    }

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

                def ready?
                    self.provisioning_state == 'AVAILABLE'
                end

                def failed?
                    self.provisioning_state == 'ERROR'
                end
            end
        end
    end
end
