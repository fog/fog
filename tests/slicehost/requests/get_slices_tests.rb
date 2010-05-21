Shindo.tests('Slicehost#get_slices', 'slicehost') do
  tests('success') do

    formats({'slices' => [Slicehost::Formats::SLICE]}) do
      Slicehost[:slices].get_slices.body
    end

  end
end
