Shindo.tests('Rackspace::Servers#list_images', 'rackspace') do
  tests('success') do

    tests('#list_images').formats({'images' => [Rackspace::Servers::Formats::SUMMARY]}) do
      Rackspace[:servers].list_images.body
    end

  end
end
