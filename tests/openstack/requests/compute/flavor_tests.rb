Shindo.tests('Fog::Compute[:openstack] | flavor requests', ['openstack']) do

  @flavor_format = {
    'id'          => String,
    'name'        => String,
    'disk'        => Integer,
    'ram'         => Integer,
    'links'       => Array,
    'swap'        => Fog::Nullable::String,
    'rxtx_factor' => Fog::Nullable::Float,
    'OS-FLV-EXT-DATA:ephemeral'   => Integer,
    'os-flavor-access:is_public'   => Fog::Nullable::Boolean,
    'OS-FLV-DISABLED:disabled'   => Fog::Nullable::Boolean,
    'vcpus'       => Integer
  }

  tests('success') do

    tests('#get_flavor_details(1)').data_matches_schema(@flavor_format) do
      Fog::Compute[:openstack].get_flavor_details("1").body['flavor']
    end

    tests('#list_flavors').data_matches_schema({'flavors' => [OpenStack::Compute::Formats::SUMMARY]}) do
      Fog::Compute[:openstack].list_flavors.body
    end

    tests('#list_flavors_detail').data_matches_schema({'flavors' => [@flavor_format]}) do
      Fog::Compute[:openstack].list_flavors_detail.body
    end

    tests('#create_flavor(attributes)').data_matches_schema({'flavor' => @flavor_format}) do
      attributes = {:flavor_id => '100', :name => 'shindo test flavor', :disk => 10, :ram => 10, :vcpus => 10, :swap => "0", :rxtx_factor => 2.4, :ephemeral => 0, :is_public => false}
      Fog::Compute[:openstack].create_flavor(attributes).body
    end

    tests('add_flavor_access(flavor_ref, tenant_id)').data_matches_schema({'flavor_access' => [{'tenant_id' => String, 'flavor_id' => String}]}) do
      Fog::Compute[:openstack].add_flavor_access(100, 1).body
    end

    tests('remove_flavor_access(flavor_ref, tenant_id)').data_matches_schema({'flavor_access' => []}) do
      Fog::Compute[:openstack].remove_flavor_access(100, 1).body
    end

    tests('list_tenants_with_flavor_access(flavor_ref)').data_matches_schema({'flavor_access' => [{'tenant_id' => String, 'flavor_id' => String}]}) do
      Fog::Compute[:openstack].list_tenants_with_flavor_access(100).body
    end

    tests('delete_flavor(flavor_id)').succeeds do
      Fog::Compute[:openstack].delete_flavor('100')
    end

    tests('#get_flavor_metadata(flavor_ref)').data_matches_schema('extra_specs' => {'cpu_arch' => String}) do
      Fog::Compute[:openstack].get_flavor_metadata("1").body
    end

    tests('#create_flavor_metadata(flavor_ref, metadata)').data_matches_schema('extra_specs' => {'cpu_arch' => String}) do
      metadata = {:cpu_arch => 'x86_64'}
      Fog::Compute[:openstack].create_flavor_metadata("1", metadata).body
    end
  end

  tests('failure') do

    tests('#get_flavor_details(0)').raises(Fog::Compute::OpenStack::NotFound) do
      Fog::Compute[:openstack].get_flavor_details("0")
    end

    tests('add_flavor_access(1234, 1)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].add_flavor_access(1234, 1).body
    end

    tests('remove_flavor_access(1234, 1)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].remove_flavor_access(1234, 1).body
    end

    tests('list_tenants_with_flavor_access(1234)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].list_tenants_with_flavor_access(1234)
    end

    tests('get_flavor_metadata(flavor_ref)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].get_flavor_metadata("1234").body
    end

    tests('create_flavor_metadata(flavor_ref)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      metadata = {:cpu_arch => 'x86_64'}
      Fog::Compute[:openstack].create_flavor_metadata("1234", metadata).body
    end
  end

end
