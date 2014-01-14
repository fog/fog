Shindo.tests("Fog::Compute[:google] | server model", ['google']) do

  @zone = 'us-central1-a'
  @disk = create_test_disk(Fog::Compute[:google], @zone)
  server_name = 'fog-test-server-' + Time.now.to_i.to_s

  model_tests(Fog::Compute[:google].servers, {:name => server_name, :zone_name => @zone, :machine_type => 'n1-standard-1', :disks => [@disk]}) do 

    @instance = nil    
    test('#bootstrap') do
      attributes = Fog.mocking? ? {:public_key_path => nil, :private_key_path => nil} : {}
      # :private_key_path
      @instance = Fog::Compute[:google].servers.bootstrap(attributes)
      @instance.ready?
    end

    test('#sshable?') do
      @instance.wait_for { sshable? }
      @instance.sshable?
    end

    test('#ssh') do
      pending if Fog.mocking?
      ssh_results = @instance.ssh("uname")
      ssh_result = ssh_results.first
      ssh_result.status == 0
    end

  end

end
