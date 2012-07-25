Shindo.tests('Fog::Compute[:openstack] | flavor requests', ['openstack']) do

  @flavor_format = {
    'id'          => String,
    'name'        => String,
    'disk'        => Integer,
    'ram'         => Integer,
    'links'       => Array,
    'swap'        => String,
    'rxtx_factor' => Fog::Nullable::Float,
    'OS-FLV-EXT-DATA:ephemeral'   => Integer,
    'vcpus'       => Integer
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

    tests('#create_flavor(attributes)').formats({'flavor' => @flavor_format}) do
      attributes = {:flavor_id => '100', :name => 'shindo test flavor', :disk => 10, :ram => 10, :vcpus => 10, :swap => "0", :rxtx_factor => 1.0, :ephemeral => 0}
      Fog::Compute[:openstack].create_flavor(attributes).body
    end

    tests('delete_flavor(flavor_id)').succeeds do
      Fog::Compute[:openstack].delete_flavor('100')
    end

  end

  tests('failure') do

    tests('#get_flavor_details(0)').raises(Fog::Compute::OpenStack::NotFound) do
      Fog::Compute[:openstack].get_flavor_details("0")
    end

  end

end
