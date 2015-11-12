Shindo.tests('Fog::Baremetal[:openstack] | Baremetal node requests', ['openstack']) do
  openstack = Fog::Identity[:openstack]

  @node_format = {
    'instance_uuid'     => Fog::Nullable::String,
    'maintenance'       => Fog::Boolean,
    'power_state'       => Fog::Nullable::String,
    'provision_state'   => Fog::Nullable::String,
    'uuid'              => String,
    'links'             => Array
  }

  @detailed_node_format = {
    'instance_uuid'          => Fog::Nullable::String,
    'maintenance'            => Fog::Boolean,
    'power_state'            => Fog::Nullable::String,
    'provision_state'        => Fog::Nullable::String,
    'uuid'                   => String,
    'created_at'             => String,
    'updated_at'             => Fog::Nullable::String,
    'chassis_uuid'           => Fog::Nullable::String,
    'console_enabled'        => Fog::Boolean,
    'driver'                 => String,
    'driver_info'            => Hash,
    'extra'                  => Hash,
    'instance_info'          => Hash,
    'last_error'             => Fog::Nullable::String,
    'maintenance_reason'     => Fog::Nullable::String,
    'properties'             => Hash,
    'provision_updated_at'   => Fog::Nullable::String,
    'reservation'            => Fog::Nullable::String,
    'target_power_state'     => Fog::Nullable::String,
    'target_provision_state' => Fog::Nullable::String,
    'links'                  => Array
  }

  tests('success') do
    tests('#list_nodes').data_matches_schema({'nodes' => [@node_format]}) do
      Fog::Baremetal[:openstack].list_nodes.body
    end

    tests('#list_nodes_detailed').data_matches_schema({'nodes' => [@detailed_node_format]}) do
      Fog::Baremetal[:openstack].list_nodes_detailed.body
    end

    tests('#create_node').data_matches_schema(@detailed_node_format) do
      node_attributes = {:driver => 'pxe_ipmitool'}
      @instance = Fog::Baremetal[:openstack].create_node(node_attributes).body
    end

    tests('#get_node').data_matches_schema(@detailed_node_format) do
      Fog::Baremetal[:openstack].get_node(@instance['uuid']).body
    end

    tests('#patch_node').data_matches_schema(@detailed_node_format) do
      Fog::Baremetal[:openstack].patch_node(
        @instance['uuid'],
        [{'op' => 'replace', 'path' => '/driver', 'value' => 'pxe_ssh'}]).body
    end

    tests('#set_node_power_state').data_matches_schema(@detailed_node_format) do
      Fog::Baremetal[:openstack].set_node_power_state(
        @instance['uuid'], 'power off').body
    end

    tests('#set_node_provision_state').data_matches_schema(@detailed_node_format) do
      Fog::Baremetal[:openstack].set_node_provision_state(
        @instance['uuid'], 'manage').body
    end

    tests('#set_node_maintenance').succeeds do
      Fog::Baremetal[:openstack].set_node_maintenance(@instance['uuid'])
    end

    tests('#unset_node_maintenance').succeeds do
      Fog::Baremetal[:openstack].unset_node_maintenance(@instance['uuid'])
    end

    tests('#delete_node').succeeds do
      Fog::Baremetal[:openstack].delete_node(@instance['uuid'])
    end
  end
end
