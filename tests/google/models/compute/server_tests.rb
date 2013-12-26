Shindo.tests("Fog::Compute[:google] | server model", ['google']) do

  @zone = 'us-central1-a'
  @disk = create_test_disk(Fog::Compute[:google], @zone)

  server_tests(Fog::Compute[:google], {:name => 'fogservername', :zone_name => @zone, :machine_type => 'n1-standard-1', :disks => [@disk]}) do 

    @instance = nil
    test('#bootstrap') do
      attributes = Fog.mocking? ? {:public_key_path => nil, :private_key_path => nil} : {}
      @instance = Fog::Compute[:google].servers.bootstrap(attributes)
      @instance.ready?
    end

    test('#sshable?') do
      @instance.wait_for { sshable? }
      @instance.sshable?
    end

    test('#ssh') do
      pending if Fog.mocking?
      @instance.ssh("uname") == "Linux"
    end

    test('#destroy') do
      response = @instance.destroy
      response.body['operationType'] == 'delete'
    end

  end

end
