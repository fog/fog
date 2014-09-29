Shindo.tests('Fog::Compute[:profitbricks] | image request', ['profitbricks', 'compute']) do

    @image_format = {
        'imageId'             => String,
        'imageName'           => String,
        'imageType'           => String,
        'imageSize'           => Integer,
        'bootable'            => String,
        'cpuHotPlug'          => String,
        'cpuHotUnPlug'        => String,
        'ramHotPlug'          => String,
        'ramHotUnPlug'        => String,
        'discVirtioHotPlug'   => String,
        'discVirtioHotUnPlug' => String,
        'nicHotPlug'          => String,
        'nicHotUnPlug'        => String,
        'osType'              => String,
        'serverIds'           => Fog::Nullable::String,
        'writeable'           => String,
        'location'            => String,
        'public'              => String,
    }

    service = Fog::Compute[:profitbricks]

    Excon.defaults[:connection_timeout] = 120

    tests('success') do
        tests('#get_all_images').formats(@image_format) do
            #puts '#get_all_images'
            data = service.get_all_images
            @image_id = data.body['getAllImagesResponse'][0]['imageId']
            data.body['getAllImagesResponse'][0]
        end

        tests('#get_image').formats(@image_format) do
            #puts '#get_image'
            data = service.get_image(@image_id)
            data.body['getImageResponse']
        end

    end

    tests('failure') do
        tests('#get_image').raises(Fog::Errors::NotFound) do
            #puts '#get_image'
            service.get_image('00000000-0000-0000-0000-000000000000')
        end
    end
end