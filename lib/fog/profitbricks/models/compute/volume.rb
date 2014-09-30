module Fog
    module Compute
        class ProfitBricks
            class Volume < Fog::Model
                identity  :id,                  :aliases => 'storageId'
                attribute :name,                :aliases => 'storageName'
                attribute :size
                attribute :creation_time,       :aliases => 'creationTime'
                attribute :modification_time,   :aliases => 'lastModificationTime'
                attribute :server_ids,          :aliases => 'serverIds'
                attribute :mount_image,         :aliases => 'mountImage'
                attribute :state,               :aliases => 'provisioningState'
                attribute :data_center_id,      :aliases => 'dataCenterId'
                attribute :data_center_version, :aliases => 'dataCenterVersion'
                attribute :request_id,          :aliases => 'requestId'

                attr_accessor :options

                def initialize(attributes={})
                    super
                end

                def save
                    requires :data_center_id, :size

                    data = service.create_storage(data_center_id, size, options)
                    merge_attributes(data.body['createStorageResponse'])
                    true
                end

                def update
                    requires :id

                    data = service.update_storage(id, options)
                    merge_attributes(data.body['updateStorageResponse'])
                    true
                end

                def attach(server_id, options={})
                    requires :id
                    
                    options = {
                        'busType'      => options[:bus_type],
                        'deviceNumber' => options[:device_number]
                    }

                    data = service.connect_storage_to_server(id, server_id, options)
                    reload
                end

                def detach(server_id)
                    requires :id

                    data = service.disconnect_storage_from_server(id, server_id)
                    reload
                end

                def destroy
                    requires :id
                    service.delete_storage(id)
                    true
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