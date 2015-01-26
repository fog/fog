require 'securerandom'

Shindo.tests("Fog::Compute[:google] | server model", ['google']) do

  @zone = 'us-central1-a'
  @disk = create_test_disk(Fog::Compute[:google], @zone)
  random_string = SecureRandom.hex

  model_tests(Fog::Compute[:google].servers, {:name => "fog-test-server-#{random_string}",
                                              :zone_name => @zone,
                                              :machine_type => 'n1-standard-1',
                                              :disks => [@disk]})

  tests('servers') do
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
      !!(@instance.ssh("uname").first.stdout =~ /Linux/)
    end

    test('#destroy') do
      response = @instance.destroy
      response.operation_type == 'delete'
    end
  end
end
