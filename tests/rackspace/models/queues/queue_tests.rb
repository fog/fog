Shindo.tests('Fog::Rackspace::Queues | queue', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Queues.new
  options = {
    :name => "fog_instance_#{Time.now.to_i.to_s}",
  }
  model_tests(service.queues, options, false) do

    tests('#stats').formats(QUEUE_STATS_FORMAT['messages']) do
      @instance.stats
    end

    tests('#enqueue("msg", 60)') do
      @instance.enqueue("msg", 60)
    end

    tests('#dequeue(60, 60)').returns(true) do
      @instance.dequeue(60, 60) do |message|
        returns("msg") { message.body }
      end
    end

    tests('#dequeue(60, 60) => with not messages').returns(false) do
      @instance.dequeue(60, 60) do |message|
      end
    end
  end
end
