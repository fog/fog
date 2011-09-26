Shindo.tests('Fog::Compute[:openstack] | flavor requests', ['openstack']) do

  @flavor_format = {
    'disk'  => Integer,
    'id'    => String,
    'name'  => String,
    'ram'   => Integer,
    'links'  => Array
  }

  tests('success') do

    tests('#get_flavor_details(1)').formats(@flavor_format) do
      Fog::Compute[:openstack].get_flavor_details("1").body['flavor']
    end

    tests('#list_flavors').formats({'flavors' => [OpenStack::Compute::Formats::SUMMARY]}) do
      Fog::Compute[:openstack].list_flavors.body
    end

    tests('#list_flavors_detail').formats({'flavors' => [@flavor_format]}) do
      Fog::Compute[:openstack].list_flavors_detail.body
    end

  end

  tests('failure') do

    tests('#get_flavor_details(0)').raises(Fog::Compute::OpenStack::NotFound) do
      Fog::Compute[:openstack].get_flavor_details("0")
    end

  end

end
