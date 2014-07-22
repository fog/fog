Shindo.tests('Fog::Compute[:profitbricks] | storage request', ['profitbricks', 'compute']) do

    @storage_format = {
        'dataCenterId'         => String,
        'dataCenterVersion'    => Integer,
        'id'                   => String,
        'size'                 => Integer,
        'name'                 => String,
        'mountImage'           =>
        {
            'imageId'   => String,
            'imageName' => String
        },
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

        tests('#create_data_center') do
            puts '#create_data_center'
            data = service.create_data_center('FogTestDataCenter', 'EUROPE')
            @data_center_id = data.body['createDataCenterResponse']['id']
            data.body['createDataCenterResponse']

        end

        tests('#get_all_images') do
            puts '#get_all_images'
            data = service.get_all_images.body['getAllImagesResponse'].find {
              |image|
              image['region'] == 'EUROPE' &&
              image['type'] == 'HDD' &&
              image['os_type'] == 'LINUX'
            }
            @image_id = data['id']
        end

        tests('#create_storage').formats(@minimal_format.merge(
          'id' => String)) do
            puts '#create_storage'
            data = service.create_storage(
                @data_center_id, 'FogTestVolume', @image_id, 5
            )
            @storage_id = data.body['createStorageResponse']['id']
            data.body['createStorageResponse']
        end

        tests('#get_all_storages').formats(@storage_format) do
            puts '#get_all_storages'
            data = service.get_all_storages
            data.body['getAllStoragesResponse'].find {
              |storage| storage['id'] == @storage_id
            }
        end

        tests('#get_storage').formats(@storage_format) do
            puts '#get_storage'
            data = service.get_storage(@storage_id)
            data.body['getStorageResponse']
        end

        tests('#update_storage').formats(@minimal_format) do
            puts '#update_storage'
            data = service.update_storage(@storage_id, 10)
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
            service.update_storage('00000000-0000-0000-0000-000000000000', 10)
        end

        tests('#delete_storage').raises(Fog::Errors::NotFound) do
            puts '#delete_storage'
            service.delete_storage('00000000-0000-0000-0000-000000000000')
        end
    end
end