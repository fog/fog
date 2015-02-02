Shindo.tests('Fog::Baremetal[:openstack] | Baremetal driver requests', ['openstack']) do
  openstack = Fog::Identity[:openstack]

  @driver_format = {
    'hosts'             => Array,
    'name'              => String
  }

  @driver_properties_format = {
    "pxe_deploy_ramdisk"    => String,
    "ipmi_transit_address"  => String,
    "ipmi_terminal_port"    => String,
    "ipmi_target_channel"   => String,
    "ipmi_transit_channel"  => String,
    "ipmi_local_address"    => String,
    "ipmi_username"         => String,
    "ipmi_address"          => String,
    "ipmi_target_address"   => String,
    "ipmi_password"         => String,
    "pxe_deploy_kernel"     => String,
    "ipmi_priv_level"       => String,
    "ipmi_bridging"         => String
  }

  tests('success') do
    tests('#list_drivers').data_matches_schema({'drivers' => [@driver_format]}) do
      instances = Fog::Baremetal[:openstack].list_drivers.body
      @instance = instances['drivers'].last
      instances
    end

    tests('#get_driver').data_matches_schema(@driver_format) do
      Fog::Baremetal[:openstack].get_driver(@instance['name']).body
    end

    tests('#get_driver_properties').data_matches_schema(@driver_properties_format) do
      Fog::Baremetal[:openstack].get_driver_properties(@instance['name']).body
    end
  end
end
