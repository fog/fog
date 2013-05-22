Shindo.tests("HP::BlockStorageV2 | snapshot model", ['hp', 'v2', 'block_storage', 'snapshots']) do

  @volume = HP[:block_storage_v2].volumes.create(:name => 'testsnap2vol', :size => 1)
  @volume.wait_for { ready? } unless Fog.mocking?

  model_tests(HP[:block_storage_v2].snapshots, {:name => 'fogsnap2tests', :description => 'fogsnaptests-desc', :volume_id => @volume.id}, true) do
    test("get(#{@instance.id})") do
      HP[:block_storage_v2].snapshots.get(@instance.id) != nil?
    end

    test("update(#{@instance.id}") do
      @instance.name = 'Updated'
      @instance.save
      @instance.reload
      @instance.name == 'Updated'
    end

  end

  @volume.destroy

end
