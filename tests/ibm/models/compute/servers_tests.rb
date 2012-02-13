Shindo.tests('Fog::Compute[:ibm] | servers', ['ibm']) do

  tests('success') do

    @name           = "fog-test-instance-" + Time.now.to_i.to_s(32)
    @image_id       = "20010001"
    @instance_type  = "BRZ32.1/2048/60*175"
    @location_id    = "41"

    @instance_id = Fog::Compute[:ibm].create_instance(@name, @image_id, @instance_type, @location_id).body["instances"][0]["id"]
    @server      = nil

    tests('Fog::Compute[:ibm].servers') do
      returns(1) { Fog::Compute[:ibm].servers.length }
    end

    tests('Fog::Compute[:ibm].servers.get("#{@instance_id}")') do
      @server = Fog::Compute[:ibm].servers.get(@instance_id)
      returns(@instance_id) { @server.id }
    end

  end

end
