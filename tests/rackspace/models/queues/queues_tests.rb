Shindo.tests('Fog::Rackspace::Queues | queues', ['rackspace']) do

  service = Fog::Rackspace::Queues.new
  options = {
    :name => "fog_instance_#{Time.now.to_i.to_s}",
  }
  collection_tests(service.queues, options)
end
