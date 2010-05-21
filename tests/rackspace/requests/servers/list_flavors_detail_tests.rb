Shindo.tests('Rackspace::Servers#list_flavors_detail', 'rackspace') do
  tests('success') do

    tests('#list_flavors_detail').formats({'flavors' => [Rackspace::Servers::Formats::FLAVOR]}) do
      Rackspace[:servers].list_flavors_detail.body
    end

  end
end
