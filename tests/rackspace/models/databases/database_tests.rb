require 'shindo_helper'
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

  instance.destroy
end
