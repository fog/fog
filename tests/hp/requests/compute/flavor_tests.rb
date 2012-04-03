Shindo.tests('Fog::Compute[:hp] | flavor requests', ['hp']) do

  @flavor_format = {
    'disk'  => Integer,
    'ram'   => Integer,
    'id'    => Integer,
    'name'  => String
  }

  @list_flavors_format = {
    'id'    => Integer,
    'name'  => String
  }

  tests('success') do

    tests('#list_flavors').formats({'flavors' => [@list_flavors_format]}) do
      Fog::Compute[:hp].list_flavors.body
    end

    tests('#get_flavor_details(1)').formats(@flavor_format) do
      Fog::Compute[:hp].get_flavor_details(1).body['flavor']
    end

    tests('#list_flavors_detail').formats({'flavors' => [@flavor_format]}) do
      Fog::Compute[:hp].list_flavors_detail.body
    end

  end

  tests('failure') do

    tests('#get_flavor_details(0)').raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].get_flavor_details(0)
    end

  end

end
