Shindo.tests('Fog::Rackspace::Databases | database', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new
  instance = service.instances.create({
    :name => "fog_instance_#{Time.now.to_i.to_s}",
    :flavor_id => 1,
    :volume_size => 1
  })

  instance.wait_for { ready? }

  model_tests(instance.databases, { :name => "db_#{Time.now.to_i.to_s}" }, false)

  user_no_host = instance.users.create(:name => "foo", :password => "foo")
  user_with_host = instance.users.create(:name => "bar", :host => "10.20.30.40", :password => "bar")
    
  db = instance.databases.create(:name => "Test_#{Time.now.to_i}")

  db.grant_access_for(user_no_host)
  db.grant_access_for(user_with_host)
  
  db.revoke_access_for(user_no_host)
  db.revoke_access_for(user_with_host)
    

  instance.destroy
end
