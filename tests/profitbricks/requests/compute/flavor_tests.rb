Shindo.tests('Fog::Compute[:profitbricks] | flavor request', ['profitbricks', 'compute']) do

    @flavor_format = {
        'flavorId'   => String,
        'flavorName' => String,
        'ram'        => Integer,
        'cores'      => Integer
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do

        # Not yet implemented
        #tests('#create_flavor').formats(@flavor_format) do
        #    puts '#create_flavor'
        #    data = service.create_flavor('FogFlavorTest', 4096, 2)
        #    data.body['createFlavorResponse']
        #end

        tests('#get_all_flavors').formats(@flavor_format) do
            #puts '#get_all_flavors'
            data = service.get_all_flavors
            @flavor_id = data.body['getAllFlavorsResponse'][0]['flavorId']
            data.body['getAllFlavorsResponse'][0]
        end

        tests('#get_flavor').formats(@flavor_format) do
            #puts '#get_flavor'
            data = service.get_flavor(@flavor_id)
            data.body['getFlavorResponse']
        end

    end

    tests('failure') do
        tests('#get_flavor').raises(Fog::Errors::NotFound) do
            #puts '#get_flavor'
            data = service.get_flavor('00000000-0000-0000-0000-000000000000')
            data.body['getRegionResponse']
        end
    end
end