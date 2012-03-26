Shindo.tests('Fog::Compute[:ibm] | servers', ['ibm']) do

  tests('success') do

    @name           = "fog-test-instance-" + Time.now.to_i.to_s(32)
    @image_id       = "20010001"
    @instance_type  = "BRZ32.1/2048/60*175"
    @location_id    = "41"
    @key_name       = "fog-test-key-" + Time.now.to_i.to_s(32)
    @key            = Fog::Compute[:ibm].keys.create(:name => @key_name)

    @n_servers   = Fog::Compute[:ibm].servers.length
    @instance_id = Fog::Compute[:ibm].create_instance(@name, @image_id, @instance_type, @location_id, :key_name => @key_name).body["instances"][0]["id"]

    tests('Fog::Compute[:ibm].servers') do
      returns(@n_servers + 1) { Fog::Compute[:ibm].servers.length }
    end

    tests('Fog::Compute[:ibm].servers.get("#{@instance_id}")') do
      @server = Fog::Compute[:ibm].servers.get(@instance_id)
      returns(@instance_id) { @server.id }
    end

    if @server.wait_for(Fog::IBM.timeout) { ready? }
      @server.destroy
    else
      pending
    end
    if @key.wait_for(Fog::IBM.timeout) { instance_ids.empty? }
      @key.destroy
    else
      pending
    end

  end

end
