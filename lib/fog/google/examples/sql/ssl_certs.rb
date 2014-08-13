def test
  connection = Fog::Google::SQL.new

  puts 'Create a Instance...'
  puts '--------------------'
  instance = connection.instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
  instance.wait_for { ready? }

  puts 'Create a SSL certificate...'
  puts '---------------------------'
  ssl_cert = connection.ssl_certs.create(:instance => instance.instance, :common_name => Fog::Mock.random_letters(16))

  puts 'Get the SSL certificate...'
  puts '--------------------------'
  connection.ssl_certs.get(instance.instance, ssl_cert.sha1_fingerprint)

  puts 'List all SSL certificate...'
  puts '---------------------------'
  connection.ssl_certs.all(instance.instance)

  puts 'Delete the SSL certificate...'
  puts '-----------------------------'
  ssl_cert.destroy

  puts 'Delete the Instance...'
  puts '----------------------'
  instance.destroy
end
