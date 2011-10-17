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
    tests("#create_tags('#{@volume.identity}', 'foo' => 'bar')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].create_tags(@volume.identity, 'foo' => 'bar').body
    end

    tests('#describe_tags').formats(@tags_format) do
      Fog::Compute[:aws].describe_tags.body
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
