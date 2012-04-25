Shindo.tests('Fog::Compute[:ibm] | server', ['ibm']) do

  tests('success') do
    # TODO: Fix this for non-mock tests
    @server         = nil
    @instance_id    = nil

    @name           = "fog-test-instance-" + Time.now.to_i.to_s(32)
    @image_id       = "20010001"
    @instance_type  = "BRZ32.1/2048/60*175"
    @location_id    = "41"

    @key_name       = "fog-test-key-" + Time.now.to_i.to_s(32)
    @key            = Fog::Compute[:ibm].keys.create(:name => @key_name)

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
      @server = Fog::Compute[:ibm].servers.get(@instance_id)
      @server.wait_for(Fog::IBM.timeout) { ready? }
    end

    tests('Fog::Compute::IBM::Server#id') do
      returns(@instance_id) { @server.id }
    end

    tests('Fog::Compute::IBM::Server#ready?') do
      returns(true) { @server.ready? }
    end

    tests('Fog::Compute::IBM::Server#state') do
      returns("Active") { @server.state }
    end

    # TODO: make this work
    # tests('Fog::Compute::IBM::Server#reboot') do
    #   returns(true) { @server.reboot }
    # end

    tests('Fog::Compute::IBM::Server#rename("name")') do
      name = @server.name + "-rename"
      returns(true) { @server.rename(name) }
      returns(name) { @server.name }
    end

    tests('Fog::Compute::IBM::Server#image') do
      returns(@image_id) { @server.image.id }
    end

    tests('Fog::Compute::IBM::Server#to_image') do
      body = @server.to_image(:name => @server.name)
      returns(@server.name) { body['name'] }
      image = Fog::Compute[:ibm].images.get(body['id'])
      image.wait_for(Fog::IBM.timeout) { ready? || state == 'New' }
      unless image.state == 'Capturing'
        returns(true) { Fog::Compute[:ibm].delete_image(image.id).body['success'] }
      end
    end

    tests('Fog::Compute::IBM::Server#expire_at') do
      returns(true) { @server.expire_at(Time.now + 60) }
    end

    tests('Fog::Compute::IBM::Server#destroy') do
      returns(true) { @server.destroy }
    end

    @key.wait_for(Fog::IBM.timeout) { instance_ids.empty? }
    @key.destroy

  end

end
