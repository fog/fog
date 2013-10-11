Shindo.tests('Fog::Rackspace::Queues | messages', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Queues.new
  queue = service.queues.create({
    :name => "fog_queue_#{Time.now.to_i.to_s}",
  })

  options = {
    :ttl => 300,
    :body => "blah"
  }

  collection_tests(queue.messages, options, false)

  queue.destroy
end
