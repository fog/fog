Shindo.tests('Slicehost#get_slice', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].create_slice(1, 3, 'foggetslice').body
      @id = @data['id']
    end

    after do
      wait_for { Slicehost[:slices].get_slice(@id).body['status'] == 'active' }
      Slicehost[:slices].delete_slice(@id)
    end

    test('has proper output format') do
      @data = Slicehost[:slices].get_slice(@id).body
      validate_data_format(@data, Slicehost::Formats::SLICE)
    end

  end

  tests('failure') do

    test('raises Forbidden error if flavor does not exist') do
      begin
        Slicehost[:slices].get_slice(0)
        false
      rescue Excon::Errors::Forbidden
        true
      end
    end

  end
end
