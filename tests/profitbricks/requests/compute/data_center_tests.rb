Shindo.tests('Fog::Compute[:profitbricks] | data_center request', ['profitbricks', 'compute']) do

    @data_center_format = {
        'requestId'         => String,
        'id'                => String,
        'name'    => String,
        'dataCenterVersion' => Integer,
        'provisioningState' => 'AVAILABLE',
        'region'            => String
    }

    @minimal_format = {
        'id'      => String,
        'dataCenterVersion' => Integer,
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do
        tests('#create_data_center').formats(@minimal_format.merge(
          'requestId' => String,
          'region'    => String
        )) do
            #puts '#create_data_center'
            data = service.create_data_center(
                'FogTestDataCenter',
                'NORTH_AMERICA'
            )
            @data_center_id = data.body['createDataCenterResponse']['id']
            data.body['createDataCenterResponse']
        end

        tests('#get_all_data_centers').formats(@minimal_format.merge(
          'name' => String
        )) do
            #puts '#get_all_data_centers'
            data = service.get_all_data_centers
            data.body['getAllDataCentersResponse'].find {
              |dc| dc['id'] == @data_center_id
            }
        end

        tests('#get_data_center').formats(@data_center_format) do
            #puts '#get_data_center'
            data = service.get_data_center(@data_center_id)
            data.body['getDataCenterResponse']
        end

        tests('#update_data_center').formats(@minimal_format.merge(
          'requestId' => String
        )) do
            #puts '#update_data_center'
            data = service.update_data_center(
                @data_center_id, 'FogTestDCRename'
            )
            data.body['updateDataCenterResponse']
        end

        tests('#get_data_center_state').formats({'return' => String}) do
            #puts '#get_data_center_state'
            data = service.get_data_center_state(@data_center_id)
            data.body['getDataCenterStateResponse']
        end

        # Request not yet available - potentially dangerous in production
        #
        #tests('#clear_data_center').formats(@data_center_format) do
        #
        #    data = service.clear_data_center(@data_center_id)
        #    data.body['clearDataCenterResponse']
        #end

        tests('#delete_data_center').formats({'requestId' => String}) do
            #puts '#delete_data_center'
            delete_data = service.delete_data_center(@data_center_id)
            delete_data.body['deleteDataCenterResponse']
        end
    end

    tests('failure') do

        tests('#create_data_center').raises(ArgumentError) do
            #puts '#create_data_center'
            service.create_data_center
        end

        tests('#get_data_center').raises(Fog::Errors::NotFound) do
            #puts '#get_data_center'
            service.get_data_center('00000000-0000-0000-0000-000000000000')
        end

        tests('#update_data_center').raises(Fog::Errors::NotFound) do
            #puts '#update_data_center'
            service.update_data_center('00000000-0000-0000-0000-000000000000')
        end

        tests('#delete_data_center').raises(Fog::Errors::NotFound) do
            #puts '#delete_data_center'
            service.update_data_center('00000000-0000-0000-0000-000000000000')
        end
    end
end
