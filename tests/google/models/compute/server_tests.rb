Shindo.tests("Fog::Compute[:google] | server model", ['google']) do

  tests('servers') do
    @instance = nil
    test('#bootstrap') do
      @instance = Fog::Compute[:google].servers.bootstrap
      @instance.ready?
    end

    test('#destroy') do
      response = @instance.destroy
      response.body['operationType'] == 'delete'
    end
  end
end
