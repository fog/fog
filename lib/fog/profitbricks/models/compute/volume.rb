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
                #attribute :server_id,              :aliases => 'serverId'
                attribute :data_center_id,         :aliases => 'dataCenterId'
                attribute :data_center_version,    :aliases => 'dataCenterVersion'
                attribute :image_id,               :aliases => 'imageId'
                attribute :image_name,             :aliases => 'imageName'
                attribute :image_password

                def initialize(attributes={})
                    super
                end

                def save
                    requires :data_center_id, :size

                    options = {
                        'storageName' => name,
                        'mountImageId' => image_id,
                        'profitBricksImagePassword' => image_password || nil
                    }

                    options = options.reject {|key, value| value.nil?}
                    data = service.create_storage(data_center_id, size, options)
                    merge_attributes(data.body['createStorageResponse'])
                    true
                end

                def update
                    requires :id

                    options = {
                        'storageName' => name,
                        'mountImageId' => image_id,
                        'profitBricksImagePassword' => image_password || nil
                    }

                    data = service.update_storage(id, options)
                    merge_attributes(data.body['updateStorageResponse'])
                    true
                end

                # * storageId<~String> - Required, UUID of virtual storage
                # * serverId<~String> - Required, 
                # * options<~Hash>:
                #   * busType<~String> - Optional, VIRTIO, IDE 
                #   * deviceNumber<~Integer> - Optional, 

                def attach(server_id)
                    requires :id
                    options = {
                        'busType' => bus_type ||= 'VIRTIO',
                        'deviceNumber' => device_number ||= '',
                    }
                    puts id
                    puts server_id
                    puts options
                    data = service.connect_storage_to_server(id, server_id, options)
                    print data
                    reload
                end

                def detach(server_id)
                    requires :id
                    options = {
                        'busType' => bus_type ||= 'VIRTIO',
                        'deviceNumber' => device_number ||= '',
                    }
                    puts id
                    puts server_id
                    puts options
                    data = service.connect_storage_to_server(id, server_id, options)
                    print data
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