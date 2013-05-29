Shindo.tests("HP::BlockStorage | volume backup model", ['hp', 'v2', 'block_storage', 'backup']) do

  @volume = HP[:block_storage_v2].volumes.create(:name => 'fogvolbkp2tests', :description => 'fogvolbkp2tests-desc', :size => 1)
  @volume.wait_for { ready? } unless Fog.mocking?

  model_tests(HP[:block_storage_v2].volume_backups, {:name => 'fogbkp2tests', :description => 'fogbkp2tests-desc', :volume_id => @volume.id}, true) do

    # restore to new volume
    tests('restore()').succeeds do
      @instance.restore
    end

    # restore to specified volume
    tests("restore(#{@volume.id})").succeeds do
      @instance.restore(@volume.id)
    end

  end

  @volume.destroy

end
