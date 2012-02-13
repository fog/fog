Shindo.tests('Fog::Compute[:ibm] | servers', ['ibm']) do

  tests('success') do

    @instance_id = Fog::Compute[:ibm].create_instance.body["instances"][0]["id"]
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
