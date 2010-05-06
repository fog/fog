Shindo.tests('Slicehost#get_flavor', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].get_flavor(1).body
    end

    test('has proper output format') do
      has_format(@data, Slicehost::Formats::FLAVOR)
    end

  end

  tests('failure') do

    test('raises Forbidden error if flavor does not exist') do
      has_error(Excon::Errors::Forbidden) do
        Slicehost[:slices].get_flavor(0)
      end
    end

  end
end
