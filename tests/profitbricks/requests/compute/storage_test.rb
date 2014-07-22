Shindo.tests('Fog::Compute[:profitbricks] | storage request', ['profitbricks', 'compute']) do

    @storage_format = {
        'request_id'             => String,
        'data_center_id'         => String,
        'data_center_version'    => Integer,
        'storage_id'             => String,
        'size'                   => Integer,
        'storage_name'           => String,
        'mount_image'            =>
        {
            'image_id'   => String,
            'image_name' => String
        },
        'provisioning_state'     => 'AVAILABLE',
        'creation_time'          => Time,
        'last_modification_time' => Time
    }

    @minimal_format = {
        'request_id'          => String,
        'data_center_id'      => String,
        'data_center_version' => Integer,
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do
        tests('#create_storage').formats(@minimal_format.merge(
          'storage_id' => String
        )) do
            #puts '#create_storage'
            @dc = service.create_storage(
                'FogTestDC',
                'NORTH_AMERICA'
            )
            @storage_id = @dc.body['createStorageResponse']['dataCenterId']
            @dc.body['createStorageResponse']
        end

        tests('#get_all_storages').formats(@minimal_format.merge(
          'dataCenterName' => String
        )) do
            #puts '#get_all_storages'
            data = service.get_all_storages
            data.body['getAllStoragesResponse'].find {
              |dc| dc['dataCenterId'] == @storage_id
            }
        end

        tests('#get_storage').formats(@storage_format) do
            #puts '#get_storage'
            data = service.get_storage(@storage_id)
            data.body['getStorageResponse']
        end

        tests('#update_storage').formats(@minimal_format.merge(
          'requestId' => String
        )) do
            #puts '#update_storage'
            data = service.update_storage(
                @storage_id, 'FogTestDCRename'
            )
            data.body['updateStorageResponse']
        end
        
        tests('#get_storage_state').formats({'return' => String}) do
            #puts '#get_storage_state'
            data = service.get_storage_state(@storage_id)
            data.body['getStorageStateResponse']
        end

        # Request not yet available - potentially dangerous in production
        #
        #tests('#clear_storage').formats(@storage_format) do
        #
        #    data = service.clear_storage(@storage_id)
        #    data.body['clearStorageResponse']
        #end

        tests('#delete_storage').formats({'requestId' => String}) do
            #puts '#delete_storage'
            delete_data = service.delete_storage(@storage_id)
            delete_data.body['deleteStorageResponse']
        end
    end

    tests('failure') do

        tests('#create_storage').raises(ArgumentError) do
            #puts '#create_storage'
            service.create_storage
        end

        tests('#get_storage').raises(Fog::Errors::NotFound) do
            #puts '#get_storage'
            service.get_storage('00000000-0000-0000-0000-000000000000')
        end

        tests('#update_storage').raises(Fog::Errors::NotFound) do
            #puts '#update_storage'
            service.update_storage('00000000-0000-0000-0000-000000000000')
        end

        tests('#delete_storage').raises(Fog::Errors::NotFound) do
            #puts '#delete_storage'
            service.update_storage('00000000-0000-0000-0000-000000000000')
        end
    end
end