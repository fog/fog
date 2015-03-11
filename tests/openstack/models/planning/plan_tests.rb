Shindo.tests("Fog::Openstack[:planning] | plan", ['openstack']) do
  @instance = Fog::Openstack[:planning].plans.first

  tests('success') do
    tests('#templates').succeeds do
      @instance.templates
    end

    tests('#master_template').succeeds do
      @instance.master_template
    end

    tests('#environment').succeeds do
      @instance.environment
    end

    tests('#provider_resource_templates').succeeds do
      @instance.provider_resource_templates
    end
  end
end
