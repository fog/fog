Shindo.tests('Fog::Compute[:profitbricks] | storage request', ['profitbricks', 'compute']) do

    @storage_format = {
        'dataCenterId'         => String,
        'dataCenterVersion'    => Integer,
        'storageId'            => String,
        'size'                 => Integer,
        'storageName'          => String,
        'mountImage'           => Hash,
        'provisioningState'    => 'AVAILABLE',
        'creationTime'         => Time,
        'lastModificationTime' => Time
    }

    @minimal_format = {
        'requestId'         => String,
        'dataCenterId'      => String,
        'dataCenterVersion' => Integer,
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do

        Excon.defaults[:connection_timeout] = 200

        tests('#create_data_center') do
            puts '#create_data_center'
            data = service.create_data_center({ 'dataCenterName' => 'FogDataCenter', 'region' => 'EUROPE' })
            @data_center_id = data.body['createDataCenterResponse']['dataCenterId']
            puts data.body['createDataCenterResponse']['datacenterId']
            data.body['createDataCenterResponse']

        end

        tests('#get_all_images') do
            puts '#get_all_images'
            data = service.get_all_images.body['getAllImagesResponse'].find { |image|
                image['region']    == 'EUROPE' &&
                image['imageType'] == 'HDD' &&
                image['osType']    == 'LINUX'
            }
            @image_id = data['imageId']
        end

        tests('#create_storage').formats(@minimal_format.merge('storageId' => String)) do
            puts '#create_storage'
            data = service.create_storage(@data_center_id, 5, {
                                          'storageName'  => 'FogVolume',
                                          'mountImageId' => @image_id }
            )
            @storage_id = data.body['createStorageResponse']['storageId']
            service.volumes.get(@storage_id).wait_for { ready? }
            data.body['createStorageResponse']
        end

        #Fog::Compute[:profitbricks].volumes.get(@storage_id).wait_for { ready? }

        tests('#get_storage').formats(@storage_format) do
            puts '#get_storage'
            data = service.get_storage(@storage_id)
            data.body['getStorageResponse']
        end

        tests('#get_all_storages').formats(@storage_format) do
            puts '#get_all_storages'
            data = service.get_all_storages
            data.body['getAllStoragesResponse'].find {
              |storage| storage['storageId'] == @storage_id
            }
        end

        tests('#update_storage').formats(@minimal_format) do
            puts '#update_storage'
            data = service.update_storage(@storage_id, { 'size' => 6 })
            data.body['updateStorageResponse']
        end

        tests('#delete_storage').formats(@minimal_format) do
            puts '#delete_storage'
            data = service.delete_storage(@storage_id)
            data.body['deleteStorageResponse']
        end

        tests('#delete_data_center') do
            puts '#delete_data_center'
            service.delete_data_center(@data_center_id)
        end
    end

    tests('failure') do

       tests('#create_storage').raises(ArgumentError) do
            puts '#create_storage'
            service.create_storage
        end

        tests('#get_storage').raises(Fog::Errors::NotFound) do
            puts '#get_storage'
            service.get_storage('00000000-0000-0000-0000-000000000000')
        end

        tests('#update_storage').raises(Fog::Errors::NotFound) do
            puts '#update_storage'
            service.update_storage('00000000-0000-0000-0000-000000000000')
        end

        tests('#delete_storage').raises(Fog::Errors::NotFound) do
            puts '#delete_storage'
            service.delete_storage('00000000-0000-0000-0000-000000000000')
        end
    end
end