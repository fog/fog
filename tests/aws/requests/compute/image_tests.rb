Shindo.tests('Fog::Compute[:aws] | image requests', ['aws']) do
  @describe_images_format = {
    'imagesSet'    => [{
      'architecture'        => String,
      'blockDeviceMapping'  => [],
      'description'         => Fog::Nullable::String,
      'hypervisor'          => String,
      'imageId'             => String,
      'imageLocation'       => String,
      'imageOwnerAlias'     => Fog::Nullable::String,
      'imageOwnerId'        => String,
      'imageState'          => String,
      'imageType'           => String,
      'isPublic'            => Fog::Boolean,
      'kernelId'            => String,
      'name'                => String,
      'platform'            => Fog::Nullable::String,
      'productCodes'        => [],
      'ramdiskId'           => Fog::Nullable::String,
      'rootDeviceName'      => String,
      'rootDeviceType'      => String,
      'stateReason'         => {},
      'tagSet'              => {},
      'virtualizationType'  => String
    }],
    'requestId'     => String,
  }

  @register_image_format = {
    'imageId'               => String,
    'requestId'             => String
  }

  tests('success') do
    # the result for this is HUGE and relatively uninteresting...
    # tests("#describe_images").formats(@images_format) do
    #   Fog::Compute[:aws].describe_images.body
    # end
    @image_id = 'ami-1aad5273'

    if Fog.mocking?
      tests("#register_image").formats(@register_image_format) do
        @image = Fog::Compute[:aws].register_image('image', 'image', '/dev/sda1').body
      end

      @image_id = @image['imageId']
      sleep 1

      tests("#describe_images('Owner' => 'self')").formats(@describe_images_format) do
        Fog::Compute[:aws].describe_images('Owner' => 'self').body
      end

      tests("#describe_images('state' => 'available')").formats(@describe_images_format) do
        Fog::Compute[:aws].describe_images('state' => 'available').body
      end
    end

    tests("#describe_images('image-id' => '#{@image_id}')").formats(@describe_images_format) do
      @other_image = Fog::Compute[:aws].describe_images('image-id' => @image_id).body
    end

    unless Fog.mocking?
      tests("#describe_images('Owner' => '#{@other_image['imageOwnerAlias']}', 'image-id' => '#{@image_id}')").formats(@describe_images_format) do
        Fog::Compute[:aws].describe_images('Owner' => @other_image['imageOwnerAlias'], 'image-id' => @image_id).body
      end
    end
  end

  tests('failure') do
    pending if Fog.mocking?

    tests("#modify_image_attribute(nil, { 'Add.Group' => ['all'] })").raises(ArgumentError) do
      Fog::Compute[:aws].modify_image_attribute(nil, { 'Add.Group' => ['all'] }).body
    end
  end
end
