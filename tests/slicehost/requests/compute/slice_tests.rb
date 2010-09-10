Shindo.tests('Slicehost::Compute | slice requests', ['slicehost']) do

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

    tests("#create_slice(1, 19, 'fogcreateslice')").formats(@slice_format.merge('root-password' => String)) do
      data = Slicehost[:compute].create_slice(1, 19, 'fogcreateslice').body
      @slice_id = data['id']
      data
    end

    Slicehost[:compute].servers.get(@slice_id).wait_for { ready? }

    tests("#get_slice(#{@slice_id})").formats(@slice_format) do
      Slicehost[:compute].get_slice(@slice_id).body
    end

    tests("#get_slices").formats({'slices' => [@slice_format]}) do
      Slicehost[:compute].get_slices.body
    end

    tests("#reboot_slice(#{@slice_id})").formats(@slice_format) do
      Slicehost[:compute].reboot_slice(@slice_id).body
    end

    Slicehost[:compute].servers.get(@slice_id).wait_for { ready? }

    tests("#delete_slice(#{@slice_id})").succeeds do
      Slicehost[:compute].delete_slice(@slice_id)
    end

  end

  tests('failure') do

    tests('#get_slice(0)').raises(Excon::Errors::Forbidden) do
      Slicehost[:compute].get_slice(0)
    end

    tests('#reboot_slice(0)').raises(Excon::Errors::Forbidden) do
      Slicehost[:compute].reboot_slice(0)
    end

    tests('#delete_slice(0)').raises(Fog::Slicehost::Compute::NotFound) do
      Slicehost[:compute].delete_slice(0)
    end

  end

end
