Shindo.tests('Rackspace::Servers#list_flavors', 'rackspace') do
  tests('success') do

    tests('#list_flavors').formats({'flavors' => [Rackspace::Servers::Formats::SUMMARY]}) do
      Rackspace[:servers].list_flavors.body
    end

  end
end
