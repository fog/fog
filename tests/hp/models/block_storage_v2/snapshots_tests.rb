Shindo.tests("HP::BlockStorageV2 | snapshots collection", ['hp', 'v2', 'block_storage', 'snapshots']) do

  @volume = HP[:block_storage_v2].volumes.create(:name => 'testsnap2vol', :size => 1)
  @volume.wait_for { ready? } unless Fog.mocking?

  collection_tests(HP[:block_storage_v2].snapshots, {:name => 'fogsnap2tests', :description => 'fogsnaptests-desc', :volume_id => @volume.id}, true)

  @volume.destroy

end
