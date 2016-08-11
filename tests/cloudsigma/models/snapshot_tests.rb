Shindo.tests('Fog::Compute[:cloudsigma] | snapshot model', ['cloudsigma']) do
  volume = Fog::Compute[:cloudsigma].volumes.create(:name => 'fogmodeltest', :size => 1024**3, :media => :disk)
  volume.wait_for { available? } unless Fog.mocking?

  snapshots = Fog::Compute[:cloudsigma].snapshots
  snapshot_create_args = {:name => 'fogtest', :drive => volume.uuid}

  model_tests(snapshots, snapshot_create_args, true) do
    @instance.wait_for(timeout=60) { available? }

    tests('#update').succeeds do
      @instance.name = 'fogtest_renamed'
      @instance.save

      @instance.reload

      returns('fogtest_renamed') { @instance.name }
    end
  end

  volume.destroy

end
