Shindo.tests('Slicehost#get_flavors', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].get_flavors.body
    end

    test('has proper output format') do
      validate_format(@data, { 'flavors' => [Slicehost::Formats::FLAVOR] })
    end

  end
end
