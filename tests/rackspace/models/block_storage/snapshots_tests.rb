Shindo.tests('Fog::Rackspace::BlockStorage | snapshots', ['rackspace']) do

  service = Fog::Rackspace::BlockStorage.new
  volume = service.volumes.create({
    :display_name => "fog_#{Time.now.to_i.to_s}",
    :size => 100
  })

  volume.wait_for { ready? }

  options = { :display_name => "fog_#{Time.now.to_i.to_s}", :volume_id => volume.id }
  collection_tests(service.snapshots, options, true) do
    @instance.wait_for { ready? }
  end

  volume.wait_for { snapshots.empty? }
  volume.destroy
end
