Shindo.tests('Slicehost#delete_slice', 'slicehost') do
  tests('success') do

    @id = Slicehost[:slices].create_slice(1, 19, 'fogdeleteslice').body['id']

    tests("#delete_slice(#{@id})").succeeds do
      Fog.wait_for { Slicehost[:slices].get_slice(@id).body['status'] == 'active' }
      Slicehost[:slices].delete_slice(@id)
    end

  end

  tests('failure') do

    tests('delete_slice(0)').raises(Excon::Errors::NotFound) do
      Slicehost[:slices].delete_slice(0)
    end

  end
end
