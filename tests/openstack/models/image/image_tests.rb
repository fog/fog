Shindo.tests("Fog::Image[:openstack] | image", ['openstack']) do

  tests('success') do
    tests('#create').succeeds do
      @instance = Fog::Image[:openstack].images.create(:name => 'test image')
      !@instance.id.nil?
    end

    tests('#update').succeeds do
      @instance.name = 'edit test image'
      @instance.update
      @instance.name == 'edit test image'
    end

    tests('#get image metadata').succeeds do
      @instance.metadata
    end

    tests('#add member').succeeds do
      @instance.add_member(@instance.owner)
    end

    tests('#show members').succeeds do
      @instance.members
    end

    tests('#remove member').succeeds do
      @instance.remove_member(@instance.owner)
    end

    tests('#destroy').succeeds do
      @instance.destroy == true
    end

  end
end
