Shindo.tests("Fog::Openstack[:planning] | plan", ['openstack']) do
  @instance = Fog::Openstack[:planning].plans.first

  tests('success') do
    tests('#add_role').succeeds do
      @role = Fog::Openstack[:planning].list_roles.body.first
      @instance.add_role(@role['uuid'])
    end

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

    tests('#patch').succeeds do
      parameter =  @instance.parameters.first
      @instance.patch(:parameters => [{"name" => parameter['name'], "value" => 'new_value'}])
    end

    tests('#remove_role').succeeds do
      @instance.remove_role(@role['uuid'])
    end

    tests('#save').succeeds do
      @instance.save
    end

    tests('#update').succeeds do
      @instance.update
    end

    tests('#destroy').succeeds do
      @instance.destroy
    end

    tests('#create').succeeds do
      @instance.create
    end
  end
end
