Shindo.tests('Fog::Compute[:aws] | volume requests', ['aws']) do

  @volume_format = {
    'availabilityZone'  => String,
    'createTime'        => Time,
    'requestId'         => String,
    'size'              => Integer,
    'snapshotId'        => Fog::Nullable::String,
    'status'            => String,
    'volumeId'          => String
  }

  @volume_attachment_format = {
    'attachTime'  => Time,
    'device'      => String,
    'instanceId'  => String,
    'requestId'   => String,
    'status'      => String,
    'volumeId'    => String
  }

  @volumes_format = {
    'volumeSet' => [{
      'availabilityZone'  => String,
      'attachmentSet'     => Array,
      'createTime'        => Time,
      'size'              => Integer,
      'snapshotId'        => Fog::Nullable::String,
      'status'            => String,
      'tagSet'            => Hash,
      'volumeId'          => String
    }],
    'requestId' => String
  }

  @server = Fog::Compute[:aws].servers.create
  @server.wait_for { ready? }

  tests('success') do

    @volume_id = nil

    tests('#create_volume').formats(@volume_format) do
      data = Fog::Compute[:aws].create_volume(@server.availability_zone, 1).body
      @volume_id = data['volumeId']
      data
    end

    tests('#create_volume from snapshot').formats(@volume_format) do
      volume = Fog::Compute[:aws].volumes.create(:availability_zone => 'us-east-1d', :size => 1)
      snapshot = Fog::Compute[:aws].create_snapshot(volume.identity).body
      data = Fog::Compute[:aws].create_volume(@server.availability_zone, nil, snapshot['snapshotId']).body
      @volume_id = data['volumeId']
      data
    end

    tests('#create_volume from snapshot with size').formats(@volume_format) do
      volume = Fog::Compute[:aws].volumes.create(:availability_zone => 'us-east-1d', :size => 1)
      snapshot = Fog::Compute[:aws].create_snapshot(volume.identity).body
      data = Fog::Compute[:aws].create_volume(@server.availability_zone, 1, snapshot['snapshotId']).body
      @volume_id = data['volumeId']
      data
    end

    Fog::Compute[:aws].volumes.get(@volume_id).wait_for { ready? }

    tests('#describe_volumes').formats(@volumes_format) do
      Fog::Compute[:aws].describe_volumes.body
    end

    tests("#describe_volumes('volume-id' => #{@volume_id})").formats(@volumes_format) do
      Fog::Compute[:aws].describe_volumes('volume-id' => @volume_id).body
    end

    tests("#attach_volume(#{@server.identity}, #{@volume_id}, '/dev/sdh')").formats(@volume_attachment_format) do
      Fog::Compute[:aws].attach_volume(@server.identity, @volume_id, '/dev/sdh').body
    end

    Fog::Compute[:aws].volumes.get(@volume_id).wait_for { state == 'in-use' }

    tests("#describe_volume('attachment.device' => '/dev/sdh')").formats(@volumes_format) do
      Fog::Compute[:aws].describe_volumes('attachment.device' => '/dev/sdh').body
    end

    tests("#detach_volume('#{@volume_id}')").formats(@volume_attachment_format) do
      Fog::Compute[:aws].detach_volume(@volume_id).body
    end

    Fog::Compute[:aws].volumes.get(@volume_id).wait_for { ready? }

    tests("#delete_volume('#{@volume_id}')").formats(AWS::Compute::Formats::BASIC) do
      Fog::Compute[:aws].delete_volume(@volume_id).body
    end

  end
  tests('failure') do

    @volume = Fog::Compute[:aws].volumes.create(:availability_zone => @server.availability_zone, :size => 1)

    tests("#attach_volume('i-00000000', '#{@volume.identity}', '/dev/sdh')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].attach_volume('i-00000000', @volume.identity, '/dev/sdh')
    end

    tests("#attach_volume('#{@server.identity}', 'vol-00000000', '/dev/sdh')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].attach_volume(@server.identity, 'vol-00000000', '/dev/sdh')
    end

    tests("#detach_volume('vol-00000000')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].detach_volume('vol-00000000')
    end

    tests("#delete_volume('vol-00000000')").raises(Fog::Compute::AWS::NotFound) do
      Fog::Compute[:aws].delete_volume('vol-00000000')
    end

    @volume.destroy

  end

  @server.destroy

end
