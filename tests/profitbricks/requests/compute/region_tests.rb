Shindo.tests('Fog::Compute[:profitbricks] | region request', ['profitbricks', 'compute']) do

    @region_format = {
        'id'   => String,
        'name' => String,
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do
        tests('#get_all_regions').formats(@region_format) do
            #puts '#get_all_regions'
            data = service.get_all_regions
            @region_id = data.body['getAllRegionsResponse'][0]['regionId']
            data.body['getAllRegionsResponse'][0]
        end

        tests('#get_region').formats(@region_format) do
            #puts '#get_region'
            data = service.get_region(@region_id)
            data.body['getRegionResponse']
        end

    end

    tests('failure') do
        tests('#get_region').raises(Fog::Errors::NotFound) do
            #puts '#get_region'
            data = service.get_region('00000000-0000-0000-0000-000000000000')
            data.body['getRegionResponse']
        end
    end
end