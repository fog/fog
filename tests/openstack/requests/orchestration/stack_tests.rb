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

  @stack_detailed_format = {
    "parent"                => Fog::Nullable::String,
    "disable_rollback"      => Fog::Boolean,
    "description"           => String,
    "links"                 => Array,
    "stack_status_reason"   => String,
    "stack_name"            => String,
    "stack_user_project_id" => String,
    "stack_owner"           => String,
    "creation_time"         => Fog::Nullable::String,
    "capabilities"          => Array,
    "notification_topics"   => Array,
    "updated_time"          => Fog::Nullable::String,
    "timeout_mins"          => Fog::Nullable::String,
    "stack_status"          => String,
    "parameters"            => Hash,
    "id"                    => String,
    "outputs"               => Array,
    "template_description"  => String
  }

  @create_format = {
    'id'                  => String,
    'links'               => Array,
  }

  tests('success') do
    tests('#create_stack("teststack")').formats(@create_format) do
      @stack = Fog::Orchestration[:openstack].create_stack("teststack").body
    end

    tests('#list_stack_data').formats({'stacks' => [@stack_format]}) do
      Fog::Orchestration[:openstack].list_stack_data.body
    end

    tests('#list_stack_data_Detailed').formats({'stacks' => [@stack_detailed_format]}) do
      Fog::Orchestration[:openstack].list_stack_data_detailed.body
    end

    tests('#update_stack("teststack")').formats({}) do
      Fog::Orchestration[:openstack].update_stack("teststack").body
    end

    tests('#patch_stack("teststack")').formats({}) do
      Fog::Orchestration[:openstack].patch_stack(@stack).body
    end

    tests('#delete_stack("teststack", "id")').formats({}) do
      Fog::Orchestration[:openstack].delete_stack("teststack", "id").body
    end
  end
end
