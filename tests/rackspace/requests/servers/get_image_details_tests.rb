Shindo.tests('Rackspace::Servers#get_image_details', 'rackspace') do
  tests('success') do

    tests('#get_image_details(19)').formats(Rackspace::Servers::Formats::IMAGE.reject {|key, value| ['progress', 'serverId'].include?(key)}) do
      Rackspace[:servers].get_image_details(19).body['image']
    end

  end
  tests('failure') do

    tests('#get_image_details(0)').raises(Excon::Errors::NotFound) do
      Rackspace[:servers].get_image_details(0)
    end

  end
end
