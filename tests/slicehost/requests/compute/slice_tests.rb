Shindo.tests('Fog::Compute[:slicehost] | slice requests', ['slicehost']) do

  @slice_format = {
    'addresses'     => [String],
    'bw-in'         => Float,
    'bw-out'        => Float,
    'flavor-id'     => Integer,
    'id'            => Integer,
    'image-id'      => Integer,
    'name'          => String,
    'progress'      => Integer,
    'status'        => String
  }

  tests('success') do

    @slice_id = nil

    tests("#create_slice(1, 305, 'fogcreateslice')").formats(@slice_format.merge('root-password' => String)) do
      pending if Fog.mocking?
      data = Fog::Compute[:slicehost].create_slice(1, 305, 'fogcreateslice').body
      @slice_id = data['id']
      data
    end

    unless Fog.mocking?
      Fog::Compute[:slicehost].servers.get(@slice_id).wait_for { ready? }
    end

    tests("#get_slice(#{@slice_id})").formats(@slice_format) do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].get_slice(@slice_id).body
    end

    tests("#get_slices").formats({'slices' => [@slice_format]}) do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].get_slices.body
    end

    tests("#reboot_slice(#{@slice_id})").formats(@slice_format) do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].reboot_slice(@slice_id).body
    end

    unless Fog.mocking?
      Fog::Compute[:slicehost].servers.get(@slice_id).wait_for { ready? }
    end

    tests("#delete_slice(#{@slice_id})").succeeds do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].delete_slice(@slice_id)
    end

  end

  tests('failure') do

    tests('#get_slice(0)').raises(Excon::Errors::Forbidden) do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].get_slice(0)
    end

    tests('#reboot_slice(0)').raises(Excon::Errors::Forbidden) do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].reboot_slice(0)
    end

    tests('#delete_slice(0)').raises(Fog::Compute::Slicehost::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:slicehost].delete_slice(0)
    end

  end

end
