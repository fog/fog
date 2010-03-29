Shindo.tests('Slicehost#get_flavor', 'slicehost') do
  tests('success') do

    test('has proper output format') do
      @data = Slicehost[:slices].get_flavor(1).body
      validate_data_format(@data, Slicehost::Formats::FLAVOR)
    end

  end

  tests('failure') do

    test('raises Forbidden error if flavor does not exist') do
      begin
        Slicehost[:slices].get_flavor(0)
        false
      rescue Excon::Errors::Forbidden
        true
      end
    end

  end
end
