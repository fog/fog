Shindo.tests('Fog::Rackspace::BlockStorage | volume', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::BlockStorage.new
  options = { :display_name => "fog_#{Time.now.to_i.to_s}", :size => 100 }

  model_tests(service.volumes, options, false) do
    @instance.wait_for { ready? }

    tests('#attached?').succeeds do
      @instance.state = 'in-use'
      returns(true) { @instance.attached? }
    end

    tests('#snapshots').succeeds do
      snapshot = service.snapshots.create({ :volume_id => @instance.id })
      snapshot.wait_for { ready? }

      returns(true) { @instance.snapshots.first.id == snapshot.id }

      snapshot.destroy
    end

    @instance.wait_for { snapshots.empty? }
  end
end
