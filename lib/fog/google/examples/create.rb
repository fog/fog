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
    :name => "fog-smoke-test-#{Time.now.to_i}",
    :disks => [disk],
    :machine_type => "n1-standard-1",
    :private_key_path => File.expand_path("~/.ssh/id_rsa"),
    :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
    :zone_name => "us-central1-a",
    :user => ENV['USER'],
    :tags => ["fog"]
  })

  # My own wait_for because it hides errors
  duration = 0
  interval = 5
  timeout = 600
  start = Time.now
  until server.sshable? || duration > timeout
    # puts duration
    # puts " ----- "

    server.reload

    # p "ready?: #{server.ready?}"
    # p "public_ip_address: #{server.public_ip_address.inspect}"
    # p "public_key: #{server.public_key.inspect}"
    # p "metadata: #{server.metadata.inspect}"
    # p "sshable?: #{server.sshable?}"

    sleep(interval.to_f)
    duration = Time.now - start
  end

  raise "Could not bootstrap sshable server." unless server.ssh("whoami")
  raise "Could not delete server." unless server.destroy
end
