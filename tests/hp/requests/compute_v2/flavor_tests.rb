Shindo.tests("Fog::Compute::HPV2 | flavor requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @flavor_format = {
    'id'         => String,
    'name'       => String,
    'vcpus'      => Integer,
    'disk'       => Integer,
    'ram'        => Integer,
    'OS-FLV-EXT-DATA:ephemeral' => Integer,
    'links'      => [Hash]
  }

  @list_flavors_format = {
    'id'    => String,
    'name'  => String,
    'links' => [Hash]
  }

  tests('success') do

    tests('#list_flavors').formats({'flavors' => [@list_flavors_format]}) do
      service.list_flavors.body
    end

    tests('#get_flavor_details("1")').formats(@flavor_format) do
      service.get_flavor_details("1").body['flavor']
    end

    tests('#list_flavors_detail').formats({'flavors' => [@flavor_format]}) do
      service.list_flavors_detail.body
    end

  end

  tests('failure') do

    tests('#get_flavor_details("9999")').raises(Fog::Compute::HPV2::NotFound) do
      service.get_flavor_details('9999')
    end

  end

end
