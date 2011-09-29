Shindo.tests('Fog::Compute[:openstack] | flavor requests', ['openstack']) do

  @flavor_format = {
    'id'    => String,
    'name'  => String,
    'disk'  => Integer,
    'ram'   => Integer,
    'links'  => Array
  }

  tests('success') do

    tests('#get_flavor_details(1)').formats(@flavor_format, false) do
      Fog::Compute[:openstack].get_flavor_details("1").body['flavor']
    end

    tests('#list_flavors').formats({'flavors' => [OpenStack::Compute::Formats::SUMMARY]}) do
      Fog::Compute[:openstack].list_flavors.body
    end

    tests('#list_flavors_detail').formats({'flavors' => [@flavor_format]}, false) do
      Fog::Compute[:openstack].list_flavors_detail.body
    end

  end

  tests('failure') do

    tests('#get_flavor_details(0)').raises(Fog::Compute::OpenStack::NotFound) do
      Fog::Compute[:openstack].get_flavor_details("0")
    end

  end

end
