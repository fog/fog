Shindo.tests('Fog::Rackspace::Databases | users', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new
  instance = service.instances.create({
    :name => "fog_instance_#{Time.now.to_i.to_s}",
    :flavor_id => 1,
    :volume_size => 1
  })

  instance.wait_for { ready? }

  options = {
    :name => "user_#{Time.now.to_i.to_s}",
    :password => "fog_user"
  }
  collection_tests(instance.users, options, false)

  instance.destroy
end
