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

  @modify_image_attribute_format = {
    'return'                => Fog::Boolean,
    'requestId'             => String
  }

  tests('success') do
    # the result for this is HUGE and relatively uninteresting...
    # tests("#describe_images").formats(@images_format) do
    #   Fog::Compute[:aws].describe_images.body
    # end
    @image_id = 'ami-1aad5273'

    if Fog.mocking?
      @other_account = Fog::Compute::AWS.new(:aws_access_key_id => 'other', :aws_secret_access_key => 'account')

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

      tests("other_account#describe_images('image-id' => '#{@image_id}')").returns([]) do
        @other_account.describe_images('image-id' => @image_id).body['imagesSet']
      end

      tests("#modify_image_attribute('#{@image_id}', 'Add.UserId' => ['#{@other_account.data[:owner_id]}'])").formats(@modify_image_attribute_format) do
        Fog::Compute[:aws].modify_image_attribute(@image_id, { 'Add.UserId' => [@other_account.data[:owner_id]] }).body
      end

      tests("other_account#describe_images('image-id' => '#{@image_id}')").returns([@image_id]) do
        @other_account.describe_images('image-id' => @image_id).body['imagesSet'].map {|i| i['imageId'] }
      end

      tests("#modify_image_attribute('#{@image_id}', 'Remove.UserId' => ['#{@other_account.data[:owner_id]}'])").formats(@modify_image_attribute_format) do
        Fog::Compute[:aws].modify_image_attribute(@image_id, { 'Remove.UserId' => [@other_account.data[:owner_id]] }).body
      end

      tests("other_account#describe_images('image-id' => '#{@image_id}')").returns([]) do
        @other_account.describe_images('image-id' => @image_id).body['imagesSet']
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
    tests("#modify_image_attribute(nil, { 'Add.Group' => ['all'] })").raises(ArgumentError) do
      Fog::Compute[:aws].modify_image_attribute(nil, { 'Add.Group' => ['all'] }).body
    end

    tests("#modify_image_attribute('ami-00000000', { 'Add.UserId' => ['123456789012'] })").raises(Fog::Compute::AWS::NotFound) do
      pending unless Fog.mocking?

      Fog::Compute[:aws].modify_image_attribute('ami-00000000', { 'Add.UserId' => ['123456789012'] }).body
    end
  end
end
