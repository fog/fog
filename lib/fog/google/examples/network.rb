def test
  connection = Fog::Compute.new({ :provider => "Google" })

  # we create a new private network
  connection.insert_network('my-private-network', '10.240.0.0/16')

  server = connection.servers.create({
    :name => "fog-smoke-test-#{Time.now.to_i}",
    :image_name => "debian-7-wheezy-v20130522",
    :machine_type => "n1-standard-1",
    :zone_name => "us-central1-a",
    :private_key_path => File.expand_path("~/.ssh/id_rsa"),
    :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
    :network => 'my-private-network',
    :external_ip => false,
    :user => ENV['USER'],
  })

  # The network won't have any firewall rules, so we won't be able to ssh in.
  server.wait_for { ready? }
end
