Shindo.tests("Fog::Compute[:google] | server model", ['google']) do

  tests('bootstrap') do
    @instance = Fog::Compute[:google].servers.bootstrap

    test('#ready?') do
      @insance.ready?
    end

    test('#destroy') do
      @instance.destroy
    end

  end
end
