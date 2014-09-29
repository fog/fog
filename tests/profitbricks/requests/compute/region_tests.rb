Shindo.tests('Fog::Compute[:profitbricks] | location request', ['profitbricks', 'compute']) do

    @location_format = {
        'locationId'   => String,
        'locationName' => String,
        'country'      => String
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do
        tests('#get_all_locations').formats(@location_format) do
            #puts '#get_all_regions'
            data = service.get_all_locations
            @location_id = data.body['getAllLocationsResponse'][0]['locationId']
            data.body['getAllLocationsResponse'][0]
        end

        tests('#get_location').formats(@location_format) do
            #puts '#get_location'
            data = service.get_location(@location_id)
            data.body['getLocationResponse']
        end

    end

    tests('failure') do
        tests('#get_location').raises(Fog::Errors::NotFound) do
            #puts '#get_location'
            data = service.get_location('00000000-0000-0000-0000-000000000000')
        end
    end
end