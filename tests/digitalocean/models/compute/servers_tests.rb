Shindo.tests('Fog::Compute[:digitalocean] | servers collection', ['digitalocean']) do
  service = Fog::Compute[:digitalocean]

  options = {
    :name => "#{fog_server_name}-#{Time.now.to_i.to_s}"
  }.merge fog_test_server_attributes

  public_key_path = File.join(File.dirname(__FILE__), '../../fixtures/id_rsa.pub')
  private_key_path = File.join(File.dirname(__FILE__), '../../fixtures/id_rsa')

  # Collection tests are consistently timing out on Travis wasting people's time and resources
  pending if Fog.mocking?

  collection_tests(service.servers, options, true) do
    @instance.wait_for { ready? }
  end

  tests("#bootstrap with public/private_key_path").succeeds do
    pending if Fog.mocking?
    @server = service.servers.bootstrap({
      :public_key_path => public_key_path,
      :private_key_path => private_key_path
    }.merge(options))
    @server.destroy
  end

  tests("#bootstrap with public/private_key").succeeds do
    pending if Fog.mocking?
    @server = service.servers.bootstrap({
      :public_key => File.read(public_key_path),
      :private_key => File.read(private_key_path)
    }.merge(options))
    @server.destroy
  end

  tests("#bootstrap with no public/private keys") do
    raises(ArgumentError, 'raises ArgumentError') { service.servers.bootstrap(options) }
  end
end
