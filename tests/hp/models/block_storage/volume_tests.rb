Shindo.tests("Fog::BlockStorage[:hp] | volumes", ['hp', 'block_storage']) do

  model_tests(Fog::BlockStorage[:hp].volumes, {:name => "fogvoltests", :description => "fogvoltests-desc", :size => 1}, true)

  tests("new volume") do
    @volume = Fog::BlockStorage[:hp].volumes.create(:name => "testvol", :size => 1)
    @volume.wait_for { ready? } unless Fog.mocking?

    test("get(#{@volume.id})") do
      Fog::BlockStorage[:hp].volumes.get(@volume.id) != nil?
    end

    test("has_attachments?") do
      @volume.has_attachments? == false
    end
    after do
      @volume.destroy
    end
  end

end
