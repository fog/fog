Shindo.tests('Rackspace::Servers#list_images_detail', 'rackspace') do
  tests('success') do

    tests('#list_images_detail').formats({'images' => [Rackspace::Servers::Formats::IMAGE]})
      Rackspace[:servers].list_images_detail.body
    end

  end
end
