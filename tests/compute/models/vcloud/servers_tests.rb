Shindo.tests("Vcloud::Compute | servers", ['vcloud']) do

  tests("#server.new('#{Vcloud::Compute::TestSupport::template}')").returns(true) do
    pending if Fog.mocking?
    @svr = Vcloud.servers.create :catalog_item_uri => Vcloud::Compute::TestSupport::template, :name => 'fog_test_run', :password => 'password'
    print "Waiting for server to be ready"
    @svr.wait_for(1200) { print '.' ; ready? }
    puts ""
    @svr.ready?
  end

  tests("#svr.power_on()").returns(true) do
    pending if Fog.mocking?
    @svr.power_on
    @svr.wait_for { on? }
    @svr.wait_for { ready? }
    @svr.on?
  end

  tests("#svr.description(\"testing\")").returns("testing") do
    pending if Fog.mocking?
    @svr.wait_for { ready? }
    @svr.description = "testing"
    @svr.save
    @svr.wait_for { ready? }
    @svr.description
  end

  # Power off only stops the OS, doesn't free up resources. #undeploy is for this.
  tests("#svr.undeploy()").returns(true) do
    pending if Fog.mocking?
    @svr.undeploy
    @svr.wait_for { off? }
    @svr.wait_for { ready? }
    @svr.off?
  end

  tests("#svr.memory(384)").returns(384) do
    pending if Fog.mocking?
    raise 'Server template memory already 384m - change to something different' if @svr.memory[:amount] == 384
    @svr.wait_for { ready? }
    @svr.memory = 384
    @svr.save
    @svr.wait_for { ready? }
    # Can take a little while for the VM to know it has different ram, and not tied to a task..
    (1..20).each do |i|
      break if @svr.reload.memory[:amount] == '384'
      sleep 1
    end
    @svr.reload.memory[:amount]
  end

  tests("#svr.add_disk(4096)").returns([2, "4096"]) do
    pending if Fog.mocking?
    raise 'Server template already has two disks' if @svr.disks.size == 2
    @svr.wait_for { ready? }
    @svr.add_disk(4096)
    @svr.save
    @svr.wait_for { ready? }
    # Can take a little while for the VM to know it has different ram, and not tied to a task..
    (1..20).each do |i|
      break if @svr.reload.disks.size == 2
      sleep 1
    end
    [
     @svr.disks.size,
     @svr.disks[1][:resource][:vcloud_capacity]
    ]
  end

  tests("#svr.delete_disk(1)").returns(1) do
    pending if Fog.mocking?
    raise "Server doesn't have two disks - did previous step fail? " if @svr.disks.size != 2
    @svr.wait_for { ready? }
    sleep 5 # otherwise complains about being busy
    @svr.delete_disk 1
    @svr.save
    @svr.wait_for { ready? }
    # Can take a little while for the VM to know it has different ram, and not tied to a task..
    (1..20).each do |i|
      break if @svr.reload.disks.size == 1
      sleep 1
    end
    @svr.disks.size
  end

  tests("#svr.destroy").raises(Excon::Errors::Forbidden) do
    pending if Fog.mocking?
    @svr.destroy
    sleep 5 # allow cleanup..
    Vcloud.servers.get(@svr.href) == nil
  end


end
