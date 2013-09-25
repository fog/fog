Shindo.tests("HP::BlockStorage | volumes", ['hp', 'block_storage', 'volumes']) do

  model_tests(HP[:block_storage].volumes, {:name => "fogvoltests", :description => "fogvoltests-desc", :size => 1}, true)

  tests("new volume") do
    @volume = HP[:block_storage].volumes.create(:name => "testvol", :size => 1)
    @volume.wait_for { ready? } unless Fog.mocking?

    test("get(#{@volume.id})") do
      HP[:block_storage].volumes.get(@volume.id) != nil?
    end

    test("has_attachments?") do
      @volume.has_attachments? == false
    end
    after do
      @volume.destroy
    end
  end

end
