def test
  connection = Fog::Compute.new({ :provider => "Google" })
  server = connection.servers.create(defaults = { 
    :name => "fog-#{Time.now.to_i}",
    :image_name => "debian-7-wheezy-v20130522",
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
