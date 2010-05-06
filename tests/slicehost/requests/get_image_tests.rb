Shindo.tests('Slicehost#get_image', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].get_image(3).body
    end

    test('has proper output format') do
      has_format(@data, Slicehost::Formats::IMAGE)
    end

  end

  tests('failure') do

    test('raises Forbidden error if flavor does not exist') do
      has_error(Excon::Errors::Forbidden)
        Slicehost[:slices].get_image(0)
      end
    end

  end
end
