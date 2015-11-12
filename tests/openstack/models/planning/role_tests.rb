Shindo.tests("Fog::Openstack[:planning] | plan", ['openstack']) do
  @instance = Fog::Openstack[:planning].roles.first

  tests('success') do
    tests('#add_role').succeeds do
      @plan = Fog::Openstack[:planning].list_plans.body.first
      @instance.add_to_plan(@plan['uuid'])
    end

    tests('#remove_role').succeeds do
      @instance.remove_from_plan(@plan['uuid'])
    end
  end
end
