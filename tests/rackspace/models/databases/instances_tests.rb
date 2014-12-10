Shindo.tests('Fog::Rackspace::Databases | instances', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new
  options = {
    :name => "fog_instance_#{Time.now.to_i.to_s}",
    :flavor_id => 1,
    :volume_size => 1
  }
  collection_tests(service.instances, options, false) do
    @instance.wait_for { ready? }
  end
end
