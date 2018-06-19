Shindo.tests('Fog::Compute[:cloudsigma] | snapshots collection', ['cloudsigma']) do
  pending if Fog.mocking?

  volume = Fog::Compute[:cloudsigma].volumes.create(:name => 'fogtest', :size => 1024**3, :media => :disk)
  volume.wait_for { available? } unless Fog.mocking?

  snapshots = Fog::Compute[:cloudsigma].snapshots
  snapshot_create_args = {:name => 'fogtest', :drive => volume.uuid}

  collection_tests(snapshots, snapshot_create_args, true) do
    @instance.wait_for(timeout=60) { available? }
  end

  volume.destroy

end
