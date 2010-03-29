Shindo.tests('Slicehost#get_image', 'slicehost') do
  tests('success') do

    test('has proper output format') do
      @data = Slicehost[:slices].get_image(3).body
      validate_data_format(@data, Slicehost::Formats::IMAGE)
    end

  end

  tests('failure') do

    test('raises Forbidden error if flavor does not exist') do
      begin
        Slicehost[:slices].get_image(0)
        false
      rescue Excon::Errors::Forbidden
        true
      end
    end

  end
end
