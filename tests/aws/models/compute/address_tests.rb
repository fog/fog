Shindo.tests("Fog::Compute[:aws] | address", ['aws']) do

  model_tests(Fog::Compute[:aws].addresses, {}, true) do

    @server = Fog::Compute[:aws].servers.create
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
    end

    tests('#server') do
      test(' == @server') do
        @server.reload
        @instance.server.public_ip_address == @instance.public_ip
      end
    end

    @server.destroy

  end

  model_tests(Fog::Compute[:aws].addresses, { :domain => "vpc" }, true)
end
