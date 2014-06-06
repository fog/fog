Shindo.tests("Fog::Compute::HPV2 | volume backups collection", ['hp', 'v2', 'block_storage', 'backup']) do

  @volume = HP[:block_storage_v2].volumes.create(:name => 'fogvolbkp2tests', :description => 'fogvolbkp2tests-desc', :size => 1)
  @volume.wait_for { ready? } unless Fog.mocking?

  collection_tests(HP[:block_storage_v2].volume_backups, {:name => 'fogbkp2tests', :description => 'fogbkp2tests-desc', :volume_id => @volume.id}, true)

  @volume.destroy
end
