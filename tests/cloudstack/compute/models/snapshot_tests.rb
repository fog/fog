def snapshot_tests(connection, params, mocks_implemented = true)
  model_tests(connection.snapshots, params[:snapshot_attributes], mocks_implemented) do
    if !Fog.mocking? || mocks_implemented
      @instance.wait_for { ready? }
    end

    @volume = @instance.connection.volumes.create(params[:volumes_attributes])
    @volume.wait_for { ready? }

    tests('create').succeeds do
      @instance.create :volume_id => @volume.id
    end

    tests('destroy').succeeds do
      @instance.destroy
    end

    @volume.destroy
  end
end

Shindo.tests("Fog::Compute[:cloudstack] | snapshot", "cloudstack") do

  config = compute_providers[:cloudstack]

  snapshot_tests(Fog::Compute[:cloudstack], config, config[:mocked]) do
    if Fog.mocking? && !mocks_implemented
      pending
    else
      responds_to(:ready?)
      responds_to(:volume)
    end
  end
end
