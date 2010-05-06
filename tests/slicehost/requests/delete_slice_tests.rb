Shindo.tests('Slicehost#delete_slice', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].create_slice(1, 3, 'fogdeleteslice').body
      @id = @data['id']
    end

    test('has proper output format') do
      Fog.wait_for { Slicehost[:slices].get_slice(@id).body['status'] == 'active' }
      Slicehost[:slices].delete_slice(@id)
    end

  end

  tests('failure') do

    test('raises NotFound error if slice does not exist') do
      has_error(Excon::Errors::NotFound) do
        Slicehost[:slices].delete_slice(0)
      end
    end

  end
end
