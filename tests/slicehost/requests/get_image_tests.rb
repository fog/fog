Shindo.tests('Slicehost#get_image', 'slicehost') do
  tests('success') do

    tests('#get_image(19)').formats(Slicehost::Formats::IMAGE) do
      Slicehost[:slices].get_image(19).body
    end

  end

  tests('failure') do

    tests('#get_image(0)').raises(Excon::Errors::Forbidden) do
      Slicehost[:slices].get_image(0)
    end

  end
end
