Shindo.tests("Fog::Compute::HPV2 | volume attachments collection", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  @server = service.servers.create(:name => 'fogserverattachtest', :flavor_id => 100, :image_id => @base_image_id)
  @server.wait_for { ready? }
  @volume = HP[:block_storage_v2].volumes.create(:name => 'fogvolumetest', :size => 1)
  @volume.wait_for { ready? }

  collection_tests(@server.volume_attachments, {:server_id => @server.id, :volume_id => @volume.id, :device => '/dev/sdf'}, true)

  @volume.destroy
  @server.destroy

end
