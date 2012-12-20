Shindo.tests('Fog::Rackspace::BlockStorage | snapshot', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::BlockStorage.new
  begin
    volume = service.volumes.create({
      :display_name => "fog_#{Time.now.to_i.to_s}",
      :size => 100
    })

    volume.wait_for { ready? }

    options = { :display_name => "fog_#{Time.now.to_i.to_s}", :volume_id => volume.id }
    model_tests(service.snapshots, options, false) do
      @instance.wait_for { ready? }
    
      tests('double save').returns(true) do
        @instance.save
      end    
    end

    volume.wait_for { snapshots.empty? }
  ensure
    volume.destroy if volume
  end
end
