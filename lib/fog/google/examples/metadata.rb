def test
  connection = Fog::Compute.new({ :provider => "Google" })

  name = "fog-smoke-test-#{Time.now.to_i}"

  disk = connection.disks.create({
    :name => name,
    :size_gb => 10,
    :zone_name => 'us-central1-a',
    :source_image => 'debian-7-wheezy-v20131120',
  })

  disk.wait_for { disk.ready? }

  server = connection.servers.create(defaults = {
    :name => name,
    :disks => [disk],
    :machine_type => "n1-standard-1",
    :zone_name => "us-central1-a",
    :private_key_path => File.expand_path("~/.ssh/id_rsa"),
    :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
  })

  server.wait_for { ready? }

  server.metadata["test"] = "foo"

  raise "Metadata was not set." unless server.metadata["test"] == "foo"
  raise "Could not delete server." unless server.destroy
end
