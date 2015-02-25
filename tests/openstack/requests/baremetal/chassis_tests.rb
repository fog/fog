Shindo.tests('Fog::Baremetal[:openstack] | Baremetal chassis requests', ['openstack']) do
  openstack = Fog::Identity[:openstack]

  @chassis_format = {
    'description' => String,
    'uuid'        => String,
    'links'       => Array
  }

  @detailed_chassis_format = {
    'description' => String,
    'uuid'        => String,
    'created_at'  => String,
    'updated_at'  => Fog::Nullable::String,
    'extra'       => Hash,
    'nodes'       => Array,
    'links'       => Array
  }

  tests('success') do
    tests('#list_chassis').data_matches_schema({'chassis' => [@chassis_format]}) do
      Fog::Baremetal[:openstack].list_chassis.body
    end

    tests('#list_chassis_detailed').data_matches_schema({'chassis' => [@detailed_chassis_format]}) do
      Fog::Baremetal[:openstack].list_chassis_detailed.body
    end

    tests('#create_chassis').data_matches_schema(@detailed_chassis_format) do
      chassis_attributes = {:description => 'description'}
      @instance = Fog::Baremetal[:openstack].create_chassis(chassis_attributes).body
    end

    tests('#get_chassis').data_matches_schema(@detailed_chassis_format) do
      Fog::Baremetal[:openstack].get_chassis(@instance['uuid']).body
    end

    tests('#patch_chassis').data_matches_schema(@detailed_chassis_format) do
      Fog::Baremetal[:openstack].patch_chassis(
          @instance['uuid'],
          [{'op' => 'replace', 'path' => '/description', 'value' => 'new description'}]).body
    end

    tests('#delete_chassis').succeeds do
      Fog::Baremetal[:openstack].delete_chassis(@instance['uuid'])
    end
  end
end
