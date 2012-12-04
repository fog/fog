Shindo.tests("Fog::BlockStorage[:hp] | bootable volumes", ['hp', 'block_storage', 'volumes']) do

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  model_tests(Fog::BlockStorage[:hp].bootable_volumes, {:name => "fogbvoltests", :description => "fogbvoltests-desc", :size => 10, :image_id => @base_image_id}, true)

  tests("new volume") do
    @volume = Fog::BlockStorage[:hp].bootable_volumes.create(:name => "testbvol", :size => 10, :image_id => @base_image_id)
    @volume.wait_for { ready? } unless Fog.mocking?

    test("get(#{@volume.id})") do
      Fog::BlockStorage[:hp].bootable_volumes.get(@volume.id) != nil?
    end

    test("has_attachments?") do
      @volume.has_attachments? == false
    end
    after do
      @volume.destroy
    end
  end

end
