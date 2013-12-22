def test
  connection = Fog::Compute.new({ :provider => "Google" })
  time = Time.now.utc.to_i
  disk = connection.disks.create({
    :name => 'foggydisk',
    :size_gb => 10,
    :zone_name => 'us-central1-a',
    :source_image => 'centos-6-v20130522',
  })

  disk.wait_for { disk.ready? }
  params = {
    :name => "fog-smoke-test-#{Time.now.to_i}",
    :machine_type => "f1-micro",
    :zone_name => "us-central1-a",
    :disks => [ disk.get_as_boot_disk(true) ],
    :user => ENV['USER']
  }

  server = connection.servers.bootstrap params

  raise "Could not bootstrap sshable server." unless server.ssh("whoami")
  raise "Could not delete server." unless server.destroy
  raise "Could not delete disk." unless disk.destroy
end
