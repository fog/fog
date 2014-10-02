Shindo.tests('Fog::Compute[:profitbricks] | server request', ['profitbricks', 'compute']) do

    @nic_format = {
        'nicId'             => String,
        'lanId'             => Integer,
        'nicName'           => 'FogNic',
        'internetAccess'    => String,
        'ip'                => Fog::Nullable::String,
        'macAddress'        => String,
        'firewall'          => Fog::Nullable::Hash,
        'dhcpActive'        => String,
        'provisioningState' => 'AVAILABLE' || 'INPROCESS',
    }

    @minimal_format = {
        'requestId'         => String,
        'dataCenterId'      => String,
        'dataCenterVersion' => Integer
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do

        Excon.defaults[:connection_timeout] = 200

        tests('#create_data_center') do
            #puts '#create_data_center'
            data = service.create_data_center('FogDataCenter', 'us/las')
            @data_center_id = data.body['createDataCenterResponse']['dataCenterId']
            data.body['createDataCenterResponse']
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

        tests('#create_server').succeeds do
            #puts '#create_server'
            data = service.create_server(@data_center_id, 1, 512, { 
                                         'serverName' => 'FogServer' })
            @server_id = data.body['createServerResponse']['serverId']
            service.servers.get(@server_id).wait_for { ready? }
            data.body['createServerResponse']
        end

        tests('#create_nic').formats(@minimal_format) do
            #puts '#create_nic'
            data = service.create_nic(@server_id, 1, { 'nicName' => 'FogNic' })
            @nic_id = data.body['createNicResponse']['nicId']
            service.interfaces.get(@nic_id).wait_for { ready? }
            data.body['createNicResponse']
        end

        tests('#get_all_nic').formats(@nic_format) do
            #puts '#get_all_nic'
            data = service.get_all_nic
            data.body['getAllNicResponse'].find { |nic| nic['nicId'] == @nic_id }
        end

        tests('#get_nic').formats(@nic_format) do
             #puts '#get_nic'
             service.get_nic(@nic_id).body['getNicResponse']
         end

        tests('#update_nic').formats(@minimal_format) do
            #puts '#update_nic'
            data = service.update_nic(@nic_id, { 'nicName' => 'FogNicRename' })
            data.body['updateNicResponse']
        end

        tests('#set_internet_access').formats(@minimal_format) do
            #puts '#set_internet_access'
            data = service.set_internet_access(@data_center_id, @lan_id, true)
            data.body['setInternetAccessResponse']
        end

        tests('#delete_nic').formats(@minimal_format) do
            #puts '#delete_nic'
            data = service.delete_nic(@nic_id)
            data.body['deleteNicResponse']
        end

        tests('#delete_server').formats(@minimal_format) do
            #puts '#delete_server'
            data = service.delete_server(@server_id)
            data.body['deleteServerResponse']
        end

        tests('#delete_data_center') do
            #puts '#delete_data_center'
            service.delete_data_center(@data_center_id)
        end
    end
end