Shindo.tests('Slicehost#get_flavors', 'slicehost') do
  tests('success') do

    tests('#get_flavors').formats({ 'flavors' => [Slicehost::Formats::FLAVOR] }) do
      Slicehost[:slices].get_flavors.body
    end

  end
end
