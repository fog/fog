def volume_tests(connection, params = {}, mocks_implemented = true)

  model_tests(connection.volumes, params[:volume_attributes], mocks_implemented) do

    if !Fog.mocking? || mocks_implemented
      @instance.wait_for { ready? }
    end
    @server = connection.servers.create(params[:server_attributes])
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
