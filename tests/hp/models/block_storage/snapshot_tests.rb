Shindo.tests("HP::BlockStorage | snapshots", ['hp', 'block_storage', 'snapshots']) do

  @volume = HP[:block_storage].volumes.create(:name => "testsnapvol", :size => 1)
  @volume.wait_for { ready? } unless Fog.mocking?

  model_tests(HP[:block_storage].snapshots, {:name => "fogsnaptests", :description => "fogsnaptests-desc", :volume_id => @volume.id}, true)

  tests("new snapshot") do
    @snapshot = HP[:block_storage].snapshots.create(:name => "testvol", :volume_id => @volume.id)
    @snapshot.wait_for { ready? } unless Fog.mocking?

    test("get(#{@snapshot.id})") do
      HP[:block_storage].snapshots.get(@snapshot.id) != nil?
    end

    after do
      @snapshot.destroy
    end
  end

  @volume.destroy

end
