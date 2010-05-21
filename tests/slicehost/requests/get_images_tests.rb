Shindo.tests('Slicehost#get_images', 'slicehost') do
  tests('success') do

    tests('#get_images').formats({ 'images' => [Slicehost::Formats::IMAGE] }) do
      Slicehost[:slices].get_images.body
    end

  end
end
