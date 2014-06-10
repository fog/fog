require 'fog/vcloud/models/compute/servers'

Shindo.tests("Vcloud::Compute | server", ['vcloud']) do

  Fog::Vcloud::Compute::SUPPORTED_VERSIONS.each do |version|
    tests("api version #{version}") do
      pending if Fog.mocking?
      instance = Fog::Vcloud::Compute.new(
        :vcloud_host => 'vcloud.example.com',
        :vcloud_username => 'username',
        :vcloud_password => 'password',
        :vcloud_version => version
      ).get_server("https://vcloud.example.com/api#{(version == '1.0') ? '/v1.0' : ''}/vApp/vm-2")

      instance.reload

      tests("#href").returns("https://vcloud.example.com/api#{(version == '1.0') ? '/v1.0' : ''}/vApp/vm-2") { instance.href }
      tests("#name").returns("vm2") { instance.name }
      tests("#vapp").returns("vApp1") { instance.vapp.name }
      tests("#description").returns("Some VM Description") { instance.description }
      tests("#status").returns('8') { instance.status }
      tests("#deployed").returns(true) { instance.deployed }

      tests("#os_desc").returns("Red Hat Enterprise Linux 5 (64-bit)") { instance.os_desc }
      tests("#os_type").returns("rhel5_64Guest") { instance.os_type }
      tests("#computer_name").returns("vm2") { instance.computer_name }

      tests("cpu count").returns(1) { instance.cpus[:count] }

      tests("amount of memory").returns(512){ instance.memory[:amount] }

      tests("#disks") do
        tests("#size").returns(2){ instance.disks.size }
        tests("#number").returns(0){ instance.disks.first[:number] }
        tests("#size").returns(1600){ instance.disks.first[:size] }
        tests("#ElementName").returns("Hard disk 1"){ instance.disks.first[:disk_data][:'rasd:ElementName'] }
        tests("#InstanceID").returns("2000"){ instance.disks.first[:disk_data][:'rasd:InstanceID'] }
      end

      tests("#vapp_scoped_local_id").returns("vmware_RHEL5-U5-64-small_v02") { instance.vapp_scoped_local_id }

      tests("#friendly_status").returns('off') { instance.friendly_status }
      tests("#on?").returns(false) { instance.on? }
      tests("#off?").returns(true) { instance.off? }

      tests("#network_connections") do
        tests("#size").returns(2) { instance.network_connections.size }
      end
    end
  end
  #old tests
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
