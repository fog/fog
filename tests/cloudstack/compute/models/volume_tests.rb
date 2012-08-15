def volume_tests(connection, params, mocks_implemented = true)
  model_tests(connection.volumes, params[:volume_attributes], mocks_implemented) do
    if !Fog.mocking? || mocks_implemented
      @instance.wait_for { ready? }
    end

    @server = @instance.connection.servers.create(params[:server_attributes])
    @server.wait_for { ready? }

    tests('attach').succeeds do
      @instance.attach(@server)
    end

    tests('detach').succeeds do
      @instance.detach
    end

    @server.destroy
  end
end

Shindo.tests("Fog::Compute[:cloudstack] | volume", "cloudstack") do

  config = compute_providers[:cloudstack]

  volume_tests(Fog::Compute[:cloudstack], config, config[:mocked]) do
    if Fog.mocking? && !mocks_implemented
      pending
    else
      responds_to(:ready?)
      responds_to(:flavor)
    end
  end
end
