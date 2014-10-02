Shindo.tests('Fog::Compute[:profitbricks] | server request', ['profitbricks', 'compute']) do

    @data_center_format = {
        'requestId'         => String,
        'dataCenterId'      => String,
        'dataCenterName'    => String,
        'dataCenterVersion' => Integer,
        'provisioningState' => 'AVAILABLE',
        'location'          => String
    }

    @server_format = {
        'serverId'             => String,
        'serverName'           => 'FogServer',
        'cores'                => Integer,
        'ram'                  => Integer,
        'internetAccess'       => String,
        'connectedStorages'    => Fog::Nullable::Array,
        'nics'                 => Fog::Nullable::Array,
        'provisioningState'    => 'AVAILABLE',
        'virtualMachineState'  => 'RUNNING',
        'creationTime'         => Time,
        'lastModificationTime' => Time,
        'osType'               => String,
        'availabilityZone'     => 'AUTO' || 'ZONE_1' || 'ZONE_2',
    }

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
        'dataCenterVersion' => Integer
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do

        Excon.defaults[:connection_timeout] = 500

        tests('#create_data_center').formats(@minimal_format.merge('location' => String)) do
            #puts '#create_data_center'
            data = service.create_data_center('FogDataCenter', 'us/las')
            @data_center_id = data.body['createDataCenterResponse']['dataCenterId']
            service.datacenters.get(@data_center_id).wait_for { ready? }
            data.body['createDataCenterResponse']
        end

        tests('#get_data_center').formats(@data_center_format) do
            #puts '#get_data_center'
            data = service.get_data_center(@data_center_id)
            data.body['getDataCenterResponse']
        end

        tests('#get_all_data_centers').formats({
            'dataCenterId' => String,
            'dataCenterName' => String,
            'dataCenterVersion' => Integer
        }) do
            #puts '#get_all_data_centers'
            data = service.get_all_data_centers
            data.body['getAllDataCentersResponse'].find { |dc|
                dc['dataCenterId'] == @data_center_id
            }
        end

        tests('#update_data_center').formats(@minimal_format) do
            #puts '#update_data_center'
            data = service.update_data_center(
                @data_center_id, { 'dataCenterName' => 'FogDataCenterRename' }
            )
            data.body['updateDataCenterResponse']
        end

        tests('#get_all_images') do
            #puts '#get_all_images'
            data = service.get_all_images.body['getAllImagesResponse'].find { |image|
                image['location'] == 'us/las' &&
                image['imageType'] == 'HDD' &&
                image['osType'] == 'LINUX'
            }
            @image_id = data['imageId']
        end

        tests('#create_storage') do
            #puts '#create_storage'
            data = service.create_storage(
                @data_center_id, 5, {
                    'storageName' => 'FogVolume',
                    'mountImageId' => @image_id
                }
            )
            @storage_id = data.body['createStorageResponse']['storageId']
            service.volumes.get(@storage_id).wait_for { ready? }
            data.body['createStorageResponse']
        end

        tests('#get_storage').formats(@storage_format) do
            #puts '#get_storage'
            data = service.get_storage(@storage_id).body['getStorageResponse']
        end

        tests('#get_all_storages').formats(@storage_format) do
            #puts '#get_all_storages'
            data = service.get_all_storages
            data.body['getAllStoragesResponse'].find {
              |storage| storage['storageId'] == @storage_id
            }
        end

        tests('#update_storage').formats(@minimal_format) do
            #puts '#update_storage'
            service.update_storage(@storage_id, { 'size' => 6 }).body['updateStorageResponse']
        end

        tests('#create_server').formats(@minimal_format.merge('serverId' => String)) do
            #puts '#create_server'
            data = service.create_server(@data_center_id, 1, 512, { 
                'serverName' => 'FogServer',
                'bootFromStorageId' => @storage_id
            })
            @server_id = data.body['createServerResponse']['serverId']
            service.servers.get(@server_id).wait_for { ready? }
            data.body['createServerResponse']
        end

        tests('#get_all_servers').formats(@server_format.merge(
            'dataCenterId' => String, 'dataCenterVersion' => Integer
        )) do
            #puts '#get_all_servers'
            data = service.get_all_servers
            data.body['getAllServersResponse'].find {
              |server| server['serverId'] == @server_id
            }
        end

        tests('#get_server').formats(@server_format.merge(@minimal_format)) do
            #puts '#get_server'
            data = service.get_server(@server_id)
            data.body['getServerResponse']
        end

        tests('#update_server').formats(@minimal_format) do
            #puts '#update_server'
            data = service.update_server(@server_id, { 'serverName' => 'FogServerRename' })
            service.servers.get(@server_id).wait_for { ready? }
            data.body['updateServerResponse']
        end

        tests('#connect_storage_to_server').formats(@minimal_format) do
            #puts '#connect_storage_to_server'
            service.connect_storage_to_server(@storage_id, @server_id).body['connectStorageToServerResponse']
        end

        tests('#stop_server').succeeds do
            #puts '#stop_server'
            service.stop_server(@server_id)
        end

        tests('#start_server').succeeds do
            #puts '#start_server'
            service.start_server(@server_id)
        end

        tests('#reset_server').succeeds do
            #puts '#reset_server'
            service.reset_server(@server_id)
        end

        tests('#disconnect_storage_from_server').formats(@minimal_format) do
            #puts '#disconnect_storage_from_server'
            service.disconnect_storage_from_server(@storage_id, @server_id).body['disconnectStorageFromServerResponse']
        end

        tests('#delete_storage').formats(@minimal_format) do
            #puts '#delete_storage'
            data = service.delete_storage(@storage_id)
            data.body['deleteStorageResponse']
        end

        tests('#delete_server').formats(@minimal_format) do
            #puts '#delete_server'
            data = service.delete_server(@server_id)
            data.body['deleteServerResponse']
        end

        tests('#clear_data_center').formats(@minimal_format) do
            data = service.clear_data_center(@data_center_id)
            data.body['clearDataCenterResponse']
        end

        tests('#delete_data_center').formats({'requestId' => String}) do
            #puts '#delete_data_center'
            service.delete_data_center(@data_center_id).body['deleteDataCenterResponse']
        end
    end

    tests('failure') do

        tests('#get_data_center').raises(Fog::Errors::NotFound) do
            #puts '#get_data_center'
            service.get_data_center('00000000-0000-0000-0000-000000000000')
        end

        tests('#update_data_center').raises(Fog::Errors::NotFound) do
            #puts '#update_data_center'
            service.update_data_center('00000000-0000-0000-0000-000000000000',
                                      { 'dataCenterName' => 'FogTestDCRename' })
        end

        tests('#delete_data_center').raises(Fog::Errors::NotFound) do
            #puts '#delete_data_center'
            service.delete_data_center('00000000-0000-0000-0000-000000000000')
        end
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
            service.delete_storage('00000000-0000-0000-0000-000000000000')
        end
    end
end