#Shindo.tests("Fog::Compute::HPV2 | volume_attachment model", ['hp', 'v2', 'compute']) do
#
#  service = Fog::Compute.new(:provider => 'HP', :version => :v2)
#
#  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'
#
#  @server = service.servers.create(:name => 'fogserattachtests', :flavor_id => 100, :image_id => @base_image_id)
#  @server.wait_for { ready? }
#  @volume = HP[:block_storage_v2].volumes.create(:display_name => 'fogvolumetest', :size => 1)
#  @volume.wait_for { ready? }
#
#  tests('success') do
#
#    tests('#create').succeeds do
#      volume_attachment = @server.volume_attachments.create(:server_id => @server.id, :volume_id => @volume.id, :device => '/dev/sdf')
#      test('volume attached to server') do
#        volume_attachment.server_id == @server.id
#      end
#    end
#
#    tests('#all').succeeds do
#      volume_attachment = @server.volume_attachments.all
#      test('list server in volume attachment') do
#        volume_attachment.server_id == @server.id
#      end
#    end
#
#    tests('#get').succeeds do
#      volume_attachment = @server.volume_attachments.get(@volume.id)
#      test('get server in volume attachment') do
#        volume_attachment.id == @volume.id
#      end
#    end
#
#    tests('#detach').succeeds do
#      volume = @server.volume_attachments.get(@volume.id)
#      volume.detach
#    end
#
#  end
#
#  @volume.destroy
#  @server.destroy
#end
