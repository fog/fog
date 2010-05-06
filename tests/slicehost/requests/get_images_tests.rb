Shindo.tests('Slicehost#get_images', 'slicehost') do
  tests('success') do

    before do
      @data = Slicehost[:slices].get_images.body
    end

    test('has proper output format') do
      has_format(@data, { 'images' => [Slicehost::Formats::IMAGE] })
    end

  end
end
