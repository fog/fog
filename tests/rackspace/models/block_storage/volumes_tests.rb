Shindo.tests('Fog::Rackspace::BlockStorage | volumes', ['rackspace']) do

  service = Fog::Rackspace::BlockStorage.new
  options = { :display_name => "fog_#{Time.now.to_i.to_s}", :size => 100 }

  collection_tests(service.volumes, options, true) do
    @instance.wait_for { ready? }
  end
end
