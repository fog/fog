def test
  connection = Fog::Compute.new({ :provider => "Google" })

  server = connection.servers.create(defaults = {
    :name => "fog-smoke-test-#{Time.now.to_i}",
    :image_name => "debian-7-wheezy-v20130522",
    :machine_type => "n1-standard-1",
    :zone_name => "us-central1-a",
    :private_key_path => File.expand_path("~/.ssh/id_rsa"),
    :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
    :user => ENV['USER'],
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
  raise "Cloud note delete server." unless server.destroy
end
