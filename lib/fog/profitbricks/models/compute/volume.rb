module Fog
    module Compute
        class ProfitBricks
            class Volume < Fog::Model
                identity  :id,                     :aliases => 'storageId'
                attribute :name,                   :aliases => 'storageName'
                attribute :size
                attribute :state,                  :aliases => 'provisioningState'
                attribute :creation_time,          :aliases => 'creationTime'
                attribute :last_modification_time, :aliases => 'lastModificationTime'
                attribute :server_ids,             :aliases => 'serverIds'
                attribute :data_center_id,         :aliases => 'dataCenterId'
                attribute :data_center_version,    :aliases => 'dataCenterVersion'
                attribute :image_id,               :aliases => 'imageId'
                attribute :image_name,             :aliases => 'imageName'

                def initialize()
                    super
                end

                def save
                    requires :data_center_id, :name, :image_id, :size
                    data = service.create_storage(data_center_id, name, image_id, size)
                    merge_attributes(data.body['createStorageResponse'])
                    true
                end

                def update
                    requires :id, :size
                    data = service.update_storage(id, size)
                    merge_attributes(data.body['updateStorageResponse'])
                    true
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