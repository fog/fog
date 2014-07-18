Shindo.tests('Fog::Compute[:profitbricks] | image request', ['profitbricks', 'compute']) do

    @image_format = {
        'id'             => String,
        'name'           => String,
        'type'           => String,
        'size'           => Integer,
        'cpu_hotplug'    => String,
        'memory_hotplug' => String,
        'server_ids'     => Fog::Nullable::String,
        'os_type'        => String,
        'writeable'      => String,
        'region'         => String,
        'public'         => String,
    }

    service = Fog::Compute[:profitbricks]

    tests('success') do
        tests('#get_all_images').formats(@image_format) do
            #puts '#get_all_images'
            data = service.get_all_images
            @image_id = data.body['getAllImagesResponse'][0]['id']
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
            data = service.get_image('00000000-0000-0000-0000-000000000000')
            data.body['getImageResponse']
        end
    end
end