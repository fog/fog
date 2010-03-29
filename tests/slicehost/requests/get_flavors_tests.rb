Shindo.tests('Slicehost#get_flavors', 'slicehost') do
  tests('success') do

    test('has proper output format') do
      @data = Slicehost[:slices].get_flavors.body
      validate_data_format(@data, { 'flavors' => [Slicehost::Formats::FLAVOR] })
    end

  end
end
