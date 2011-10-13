Shindo.tests('Fog::Compute[:aws] | tag requests', ['aws']) do
  @tags_format = {
    'tagSet'    => [{
      'key'          => String,
      'resourceId'   => String,
      'resourceType' => String,
      'value'        => Fog::Nullable::String
    }],
    'requestId' => String
  }

  @volume = Fog::Compute[:aws].volumes.create(:availability_zone => 'us-east-1a', :size => 1)
  @volume.wait_for { ready? }

  tests('success') do
    if Fog.mocking?
      @other_account = Fog::Compute::AWS.new(:aws_access_key_id => 'other', :aws_secret_access_key => 'account')
      @image_id = Fog::Compute[:aws].register_image('image', 'image', '/dev/sda1').body['imageId']
    end

    tests("#create_tags('#{@volume.identity}', 'foo' => 'bar')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].create_tags(@volume.identity, 'foo' => 'bar').body
    end

    if Fog.mocking?
      tests("#create_tags('#{@image_id}', 'foo' => 'baz')").formats(AWS::Compute::Formats::BASIC) do
        Fog::Compute[:aws].create_tags(@image_id, 'foo' => 'baz').body
      end
    end

    tests('#describe_tags').formats(@tags_format) do
      Fog::Compute[:aws].describe_tags.body
    end

    expected_identities = Fog.mocking? ? [@volume.identity, @image_id] : [@volume.identity]
    tests('#describe_tags').succeeds do
      (expected_identities - Fog::Compute[:aws].describe_tags.body['tagSet'].map {|t| t['resourceId'] }).empty?
    end

    tests("#describe_tags('key' => 'foo', 'value' => 'bar')").returns([@volume.identity]) do
      Fog::Compute[:aws].describe_tags('key' => 'foo', 'value' => 'bar').body['tagSet'].map {|t| t['resourceId'] }
    end

    if Fog.mocking?
      tests("#describe_tags('key' => 'foo', 'value' => 'baz')").returns([@image_id]) do
        Fog::Compute[:aws].describe_tags('key' => 'foo', 'value' => 'baz').body['tagSet'].map {|t| t['resourceId'] }
      end

      Fog::Compute[:aws].modify_image_attribute(@image_id, 'Add.UserId' => [@other_account.data[:owner_id]])

      tests("other_account#describe_tags('key' => 'foo', 'value' => 'baz')").returns([]) do
        @other_account.describe_tags('key' => 'foo', 'value' => 'baz').body['tagSet'].map {|t| t['resourceId'] }
      end

      tests("other_account#create_tags('#{@image_id}', 'foo' => 'quux')").formats(AWS::Compute::Formats::BASIC) do
        @other_account.create_tags(@image_id, 'foo' => 'quux').body
      end

      tests("other_account#describe_tags('key' => 'foo', 'value' => 'quux')").returns([@image_id]) do
        @other_account.describe_tags('key' => 'foo', 'value' => 'quux').body['tagSet'].map {|t| t['resourceId'] }
      end
    end

    tests("#delete_tags('#{@volume.identity}', 'foo' => 'bar')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].delete_tags(@volume.identity, 'foo' => 'bar').body
    end
  end

  tests('failure') do
    tests("#create_tags('vol-00000000', 'baz' => 'qux')").raises(Fog::Service::NotFound) do
      Fog::Compute[:aws].create_tags('vol-00000000', 'baz' => 'qux')
    end

  end

  @volume.destroy
end
