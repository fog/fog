Shindo.tests('Slicehost#get_slices', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].get_slices.body
    end

    test('has proper output format') do
      has_format(@data, { 'slices' => [Slicehost::Formats::SLICE] })
    end

  end
end
