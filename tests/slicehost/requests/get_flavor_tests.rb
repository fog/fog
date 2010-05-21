Shindo.tests('Slicehost#get_flavor', 'slicehost') do
  tests('success') do

    tests('#get_flavor(1)').formats(Slicehost::Formats::FLAVOR) do
      Slicehost[:slices].get_flavor(1).body
    end

  end

  tests('failure') do

    tests('#get_flavor(0)').raises(Excon::Errors::Forbidden) do
      Slicehost[:slices].get_flavor(0)
    end

  end
end
