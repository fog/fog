Shindo.tests('Fog::Compute[:profitbricks] | server request', ['profitbricks', 'compute']) do

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
        'dataCenterVersion' => Integer
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do

        Excon.defaults[:connection_timeout] = 500

        tests('#create_data_center') do
            puts '#create_data_center'
            data = service.create_data_center({'dataCenterName' => 'FogDataCenter', 'region' => 'EUROPE'})
            @data_center_id = data.body['createDataCenterResponse']['dataCenterId']
            service.datacenters.get(@data_center_id).wait_for { ready? }
            data.body['createDataCenterResponse']
        end

        tests('#get_all_images') do
            puts '#get_all_images'
            data = service.get_all_images.body['getAllImagesResponse'].find { |image|
              image['region'] == 'EUROPE' &&
              image['imageType'] == 'HDD' &&
              image['osType'] == 'LINUX'
            }
            @image_id = data['imageId']
        end

        tests('#create_storage') do
            puts '#create_storage'
            data = service.create_storage(
                @data_center_id, 5, { 'storageName' => 'FogVolume',
                                      'mountImageId' => @image_id }
            )
            @storage_id = data.body['createStorageResponse']['storageId']
            service.volumes.get(@storage_id).wait_for { ready? }
            data.body['createStorageResponse']
        end

        tests('#get_storage') do
            puts '#get_storage'
            data = service.get_storage(@storage_id)
            data.body['getStorageResponse']
        end

        tests('#create_server').formats(@minimal_format.merge('serverId' => String)) do
            puts '#create_server'
            data = service.create_server(@data_center_id, 1, 512, { 
                   'serverName' => 'FogServer','bootFromStorageId' => @storage_id })
            @server_id = data.body['createServerResponse']['serverId']
            service.servers.get(@server_id).wait_for { ready? }
            data.body['createServerResponse']
        end

        tests('#get_all_servers').formats(@server_format.merge('dataCenterId' => String, 'dataCenterVersion' => Integer)) do
            puts '#get_all_servers'
            data = service.get_all_servers
            data.body['getAllServersResponse'].find {
              |server| server['serverId'] == @server_id
            }
        end

        tests('#get_server').formats(@server_format.merge(@minimal_format)) do
            puts '#get_server'
            data = service.get_server(@server_id)
            data.body['getServerResponse']
        end

        tests('#update_server').formats(@minimal_format) do
            puts '#update_server'
            data = service.update_server(@server_id, { 'serverName' => 'FogServerRename' })
            service.servers.get(@server_id).wait_for { ready? }
            data.body['updateServerResponse']
        end

        tests('#connect_storage_to_server').formats(@minimal_format) do
            puts '#connect_storage_to_server'
            service.connect_storage_to_server(@storage_id, @server_id).body['connectStorageToServerResponse']
        end

        tests('#stop_server').succeeds do
            puts '#stop_server'
            service.stop_server(@server_id)
            #service.servers.get(@server_id).wait_for { self.machine_state == 'SHUTOFF' }
        end

        tests('#start_server').succeeds do
            puts '#start_server'
            service.start_server(@server_id)
            #service.servers.get(@server_id).wait_for { self.machine_state == 'RUNNING' }
        end

        tests('#reset_server').succeeds do
            puts '#reset_server'
            service.reset_server(@server_id)
            #service.servers.get(@server_id).wait_for { self.machine_state == 'RUNNING' }
        end

        tests('#disconnect_storage_from_server').formats(@minimal_format) do
            puts '#disconnect_storage_from_server'
            service.disconnect_storage_from_server(@storage_id, @server_id).body['disconnectStorageFromServerResponse']
        end

        tests('#delete_storage').formats(@minimal_format) do
            puts '#delete_storage'
            data = service.delete_storage(@storage_id)
            data.body['deleteStorageResponse']
        end

        tests('#delete_server').formats(@minimal_format) do
            puts '#delete_server'
            data = service.delete_server(@server_id)
            data.body['deleteServerResponse']
        end

        tests('#delete_data_center') do
            puts '#delete_data_center'
            service.delete_data_center(@data_center_id)
        end
    end
end