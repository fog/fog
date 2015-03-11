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

    tests('#get_plan_templates').data_matches_schema(@plan_templates_format) do
      Fog::Openstack[:planning].get_plan_templates(@instance['uuid']).body
    end
  end
end
