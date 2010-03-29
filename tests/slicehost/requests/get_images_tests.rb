Shindo.tests('Slicehost#get_images', 'slicehost') do
  tests('success') do

    test('has proper output format') do
      @data = Slicehost[:slices].get_images.body
      validate_data_format(@data, { 'images' => [Slicehost::Formats::IMAGE] })
    end

  end
end
