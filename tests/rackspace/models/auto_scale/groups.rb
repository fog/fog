Shindo.tests('Fog::Rackspace::AutoScale | groups', ['rackspace', 'rackspace_autoscale']) do 
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  tests("success") do
    tests("#all").succeeds do
      groups = service.groups.all
      @group_id = groups.first.id
    end

    tests("#get").succeeds do
      service.groups.get(@group_id)
    end
  end

  tests("failure").returns(nil) do
    service.groups.get(123)
  end

end