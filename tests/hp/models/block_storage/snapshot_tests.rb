Shindo.tests("Fog::BlockStorage[:hp] | snapshots", ['hp', 'block_storage', 'snapshots']) do

  @volume = Fog::BlockStorage[:hp].volumes.create(:name => "testsnapvol", :size => 1)
  @volume.wait_for { ready? } unless Fog.mocking?

  model_tests(Fog::BlockStorage[:hp].snapshots, {:name => "fogsnaptests", :description => "fogsnaptests-desc", :volume_id => @volume.id}, true)

  tests("new snapshot") do
    @snapshot = Fog::BlockStorage[:hp].snapshots.create(:name => "testvol", :volume_id => @volume.id)
    @snapshot.wait_for { ready? } unless Fog.mocking?

    test("get(#{@snapshot.id})") do
      Fog::BlockStorage[:hp].snapshots.get(@snapshot.id) != nil?
    end

    after do
      @snapshot.destroy
    end
  end

  @volume.destroy

end
