Shindo.tests("Fog::Openstack[:planning] | plans", ['openstack']) do
  tests('success') do
    tests('#all').succeeds do
      plans = Fog::Openstack[:planning].plans.all
      @instance = plans.first
    end

    tests('#get').succeeds do
      Fog::Openstack[:planning].plans.get(@instance.uuid)
    end

    tests('#find_by_*').succeeds do
      plan = Fog::Openstack[:planning].plans.find_by_name(@instance.name)
      plan.name == @instance.name
    end
  end
end

