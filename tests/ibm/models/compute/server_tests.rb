Shindo.tests('Fog::Compute[:ibm] | server', ['ibm']) do

  tests('success') do
    # TODO: Fix this for non-mock tests
    @server         = nil
    @instance_id    = nil

    @name           = "fog-test-instance-" + Time.now.to_i.to_s(32)
    @image_id       = "20015393"
    @instance_type  = "BRZ32.1/2048/60*175"
    @location_id    = "101"
    @key_name       = "test"

    tests('Fog::Compute::IBM::Server.new') do
      @server = Fog::Compute[:ibm].servers.new(
        :name           => @name,
        :image_id       => @image_id,
        :instance_type  => @instance_type,
        :location_id    => @location,
        :key_name       => @key_name
      )
      returns(@name) { @server.name }
    end

    tests('Fog::Compute::IBM::Server#save') do
      returns(true)   { @server.save }
      returns(String) { @server.id.class }
      @instance_id = @server.id
    end

    tests('Fog::Compute::IBM::Server#wait_for { ready? }') do
      Fog::Compute[:ibm].servers.get(@instance_id).wait_for { ready? }
      @server = Fog::Compute[:ibm].servers.last
    end

    tests('Fog::Compute::IBM::Server#id') do
      returns(@instance_id) { @server.id }
    end

    tests('Fog::Compute::IBM::Server#ready?') do
      returns(true) { @server.ready? }
    end

    tests('Fog::Compute::IBM::Server#status') do
      returns("Active") { @server.state }
    end

    tests('Fog::Compute::IBM::Server#reboot') do
      returns(true) { @server.reboot }
    end

    tests('Fog::Compute::IBM::Server#rename("name")') do
      name = @server.name + "-rename"
      returns(true) { @server.rename(name) }
      returns(name) { @server.name }
    end

    tests('Fog::Compute::IBM::Server#image') do
      returns(@image_id) { @server.image.id }
    end

    tests('Fog::Compute::IBM::Server#to_image') do
      data = @server.to_image(:name => @server.name)
      returns(@server.name) { data['name'] }
      returns(true) { Fog::Compute[:ibm].delete_image(data['id']).body['success'] }
    end

    tests('Fog::Compute::IBM::Server#expire!') do
      returns(true) { @server.expire! }
    end

    tests('Fog::Compute::IBM::Server#destroy') do
      returns(true) { @server.destroy }
    end

  end

end
