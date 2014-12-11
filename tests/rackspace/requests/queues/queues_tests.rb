Shindo.tests('Fog::Rackspace::Queues | queue_tests', ['rackspace']) do
  service = Fog::Rackspace::Queues.new

  tests('success') do
    queue_name = 'fog' + Time.now.to_i.to_s

    tests("#create_queue(#{queue_name})").succeeds do
      service.create_queue(queue_name)
    end

    tests("#list_queues").formats(LIST_QUEUES_FORMAT) do
      response = service.list_queues
      response.body
    end

    tests("#get_queue(#{queue_name})").formats(QUEUE_FORMAT) do
      service.get_queue(queue_name).body
    end

    tests("#get_queue_stats(#{queue_name})").formats(QUEUE_STATS_FORMAT) do
      service.get_queue_stats(queue_name).body
    end

    tests("#delete_queue(#{queue_name})").succeeds do
      service.delete_queue(queue_name)
    end
  end

  tests('failure') do
    tests("#create_queue('') => Invalid Create Critera").raises(Fog::Rackspace::Queues::MethodNotAllowed) do
      service.create_queue('')
    end

    tests("#get_queue('nonexistentqueue') => Does not exist").raises(Fog::Rackspace::Queues::NotFound) do
      service.get_queue('nonexistentqueue')
    end
  end
end
