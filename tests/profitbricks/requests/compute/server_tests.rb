Shindo.tests('Fog::Compute[:profitbricks] | server request', ['profitbricks', 'compute']) do

    @server_format = {
        'id'                   => String,
        'serverName'           => 'FogServer',
        'cores'                => Integer,
        'ram'                  => Integer,
        'internetAccess'       => String,
        'ips'                  => [],
        'connectedStorages'    =>
        [{
            'dataCenterId'      => String,
            'dataCenterVersion' => Integer,
            'id'                => String,
            'size'              => Integer,
            'name'              => 'FogTestVolume',
            'mountImage'        =>
            {
                'imageId'   => String,
                'imageName' => String
            },
            'provisioningState'    => 'AVAILABLE',
            'creationTime'         => Time,
            'lastModificationTime' => Time
        }],
        'romDrives'            => [],
        'nics'                 => [],
        'provisioningState'    => 'AVAILABLE',
        'virtualMachineState'  => 'RUNNING',
        'creationTime'         => Time,
        'lastModificationTime' => Time,
        'osType'               => String,
        'availabilityZone'     => 'AUTO' || 'ZONE_1' || 'ZONE_2',
        #'cpuHotPlug'           => String,
        #'ramHotPlug'           => String,
        #'nicHotPlug'           => String,
        #'nicHotUnPlug'         => String,
        #'discVirtioHotPlug'    => String,
        #'discVirtioHotUnPlug'  => String
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

        tests('#create_server').formats(@minimal_format.merge('id' => String)) do
            puts '#create_server'
            data = service.create_server(@data_center_id, 1, 1024, 'FogServer',
                                         0, '', 'false', 1, 'LINUX', 'AUTO')
            @server_id = data.body['createServerResponse']['id']
            data.body['createServerResponse']
        end

        tests('#connect_storage_to_server').formats(@minimal_format) do
            puts '#connect_storage_to_server'
            data = service.connect_storage_to_server('VIRTIO', 0, @storage_id,
                                                     @server_id)
            data.body['connectStorageToServerResponse']
        end

        tests('#get_all_servers').formats(@server_format) do
            puts '#get_all_servers'
            data = service.get_all_servers
            data.body['getAllServersResponse'].find {
              |server| server['id'] == @server_id
            }
        end

        tests('#get_server').formats(@server_format) do
            puts '#get_server'
            data = service.get_server(@server_id)
            data.body['getServerResponse']
        end

        #tests('#update_server').formats(@server_format) do
        #    puts '#update_server'
        #    data = service.update_server(@server_id)
        #    data.body['updateServerResponse']
        #end

        #tests('#start_server')

        #tests('#reset_server')

        #tests('#stop_server')

        tests('#disconnect_storage_from_server').formats(@minimal_format) do
            puts '#disconnect_storage_from_server'
            data = service.disconnect_storage_from_server(@server_id, @storage_id)
            data.body['disconnectStorageFromServerResponse']
        end

        tests('#delete_server').formats(@minimal_format) do
            puts '#delete_server'
            data = service.delete_server(@server_id)
            data.body['deleteServerResponse']
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

        #tests('#create_storage').raises(ArgumentError) do
        #    puts '#create_storage'
        #    service.create_storage
        #end

        #tests('#get_storage').raises(Fog::Errors::NotFound) do
        #    puts '#get_storage'
        #    service.get_storage('00000000-0000-0000-0000-000000000000')
        #end

        #tests('#update_storage').raises(Fog::Errors::NotFound) do
        #    puts '#update_storage'
        #    service.update_storage('00000000-0000-0000-0000-000000000000', 10)
        #end

        #tests('#delete_storage').raises(Fog::Errors::NotFound) do
        #    puts '#delete_storage'
        #    service.delete_storage('00000000-0000-0000-0000-000000000000')
        #end
    end
end