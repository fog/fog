Shindo.tests('Fog::Openstack[:planning] | Planning plan requests', ['openstack']) do
  openstack = Fog::Identity[:openstack]

  @plan_format = {
    "created_at" => Fog::Nullable::String,
    "description" => Fog::Nullable::String,
    "name" => String,
    "parameters" => Fog::Nullable::Array,
    "roles" => Fog::Nullable::Array,
    "updated_at" => Fog::Nullable::String,
    "uuid" => String,
    "version" => Fog::Nullable::Integer,
  }

  @plan_templates_format = Hash

  tests('success') do
    tests('#list_plans').data_matches_schema([@plan_format]) do
      plans = Fog::Openstack[:planning].list_plans.body
      @instance = plans.first
      plans
    end

    tests('#get_plan').data_matches_schema(@plan_format) do
      Fog::Openstack[:planning].get_plan(@instance['uuid']).body
    end

    tests('#delete_plan').succeeds do
      Fog::Openstack[:planning].delete_plan(@instance['uuid'])
    end

    tests('#create_plan').data_matches_schema(@plan_format) do
      plan_attributes = {
        :name        => 'test-plan-name',
        :description => 'test-plan-desc',
      }
      @instance = Fog::Openstack[:planning].create_plan(plan_attributes).body
    end

    tests('#add_role_to_plan').data_matches_schema(@plan_format) do
      @role_instance = Fog::Openstack[:planning].list_roles.body.first
      Fog::Openstack[:planning].add_role_to_plan(@instance['uuid'], @role_instance['uuid']).body
    end

    tests('#patch_plan').data_matches_schema(@plan_format) do
      parameters = Fog::Openstack[:planning].get_plan(@instance['uuid']).body['parameters'][0..1]
      plan_parameters = parameters.map do |parameter|
        {
          "name" => parameter['name'],
          "value" => "test-#{parameter['name']}-value",
        }
      end
      Fog::Openstack[:planning].patch_plan(@instance['uuid'], plan_parameters).body
    end

    tests('#get_plan_templates').data_matches_schema(@plan_templates_format) do
      Fog::Openstack[:planning].get_plan_templates(@instance['uuid']).body
    end

    tests('#remove_role_from_plan').data_matches_schema(@plan_format) do
      Fog::Openstack[:planning].remove_role_from_plan(@instance['uuid'], @role_instance['uuid']).body
    end

  end
end
