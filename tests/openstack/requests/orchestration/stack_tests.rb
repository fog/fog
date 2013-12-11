Shindo.tests('Fog::Orchestration[:openstack] | stack requests', ['openstack']) do
  @stack_format = {
    'links'               => Array,
    'id'                  => String,
    'stack_name'          => String,
    'description'         => Fog::Nullable::String,
    'stack_status'        => String,
    'stack_status_reason' => String,
    'creation_time'       => Time,
    'updated_time'        => Time
  }

  @create_format = {
    'id'                  => String,
    'links'               => Array,
  }

  tests('success') do
    tests('#create_stack("teststack")').formats(@create_format) do
      Fog::Orchestration[:openstack].create_stack("teststack").body
    end

    tests('#list_stacks').formats({'stacks' => [@stack_format]}) do
      Fog::Orchestration[:openstack].list_stacks.body
    end

    tests('#update_stack("teststack")').formats({}) do
      Fog::Orchestration[:openstack].update_stack("teststack").body
    end

    tests('#delete_stack("teststack", "id")').formats({}) do
      Fog::Orchestration[:openstack].delete_stack("teststack", "id").body
    end
  end
end
