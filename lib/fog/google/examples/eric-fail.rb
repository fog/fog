def test
  connection = Fog::Compute.new({ :provider => "Google" })

  server = connection.servers.create(defaults = {
    :name => "fog-smoke-test-#{Time.now.to_i}",
    :image_name => "debian-7-wheezy-v20130617",
    :machine_type => "n1-standard-1",
    :zone_name => "us-central1-a",
    :private_key_path => File.expand_path("~/.ssh/id_rsa"),
    :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
    :username => 'root',
    :metadata => {'foo' => 'bar'}
  })
  sleep(30)

  raise "Could not reload created server." unless server.reload
  raise "Could not create sshable server." unless server.ssh("whoami")
  raise "Cloud note delete server." unless server.destroy
end
