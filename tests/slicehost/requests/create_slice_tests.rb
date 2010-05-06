Shindo.tests('Slicehost#create_slice', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].create_slice(1, 3, 'fogcreateslice').body
      @id = @data['id']
    end

    after do
      Fog.wait_for { Slicehost[:slices].get_slice(@id).body['status'] == 'active' }
      Slicehost[:slices].delete_slice(@id)
    end

    test('has proper output format') do
      has_format(@data, Slicehost::Formats::SLICE.merge('root-password' => String))
    end

  end
end
