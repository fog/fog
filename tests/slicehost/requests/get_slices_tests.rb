Shindo.tests('Slicehost#get_slices', 'slicehost') do
  tests('success') do

    test('has proper output format') do
      @data = Slicehost[:slices].get_slices.body
      validate_data_format(@data, { 'slices' => [Slicehost::Formats::SLICE] })
    end

  end
end
