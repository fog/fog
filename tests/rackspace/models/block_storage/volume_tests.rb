Shindo.tests('Fog::Rackspace::BlockStorage | volume', ['rackspace']) do

  service = Fog::Rackspace::BlockStorage.new
  options = { :display_name => "fog_#{Time.now.to_i.to_s}", :size => 100 }

  model_tests(service.volumes, options, true) do
    @instance.wait_for{ ready? }

    tests('double save').raises(Fog::Rackspace::BlockStorage::IdentifierTaken) do
      @instance.save
    end

    tests('#attached?').succeeds do
      @instance.state = 'in-use'
      returns(true) { @instance.attached? }
    end

    tests('#snapshots').succeeds do
      begin
        snapshot = @instance.create_snapshot
        snapshot.wait_for { ready? }

        returns(true) { @instance.snapshots.first.id == snapshot.id }
      ensure
        snapshot.destroy if snapshot
      end
    end

    @instance.wait_for { snapshots.empty? }
  end
end
