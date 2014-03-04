Shindo.tests('Fog::Rackspace::Queues | claim', ['rackspace']) do

  service = Fog::Rackspace::Queues.new
  queue = service.queues.create({
    :name => "fog_queue_#{Time.now.to_i.to_s}",
  })
  queue.messages.create({
    :ttl => VALID_TTL,
    :body => { :random => :body }
  })

  params = {
    :ttl => VALID_TTL,
    :grace => VALID_GRACE
  }

  begin
    model_tests(queue.claims, params) do
      tests('#messages') do
        returns(1) { @instance.messages.length }
        returns('body') { @instance.messages.first.body['random'] }
      end

      tests('#update').succeeds do
        @instance.ttl = VALID_TTL + 5
        @instance.save
      end
    end

    queue.messages.create({
      :ttl => VALID_TTL,
      :body => { :random => :body }
    })
    tests('destroying claimed messages').succeeds do
      claim = queue.claims.create(params)
      claim.messages.first.destroy
    end
  ensure
    queue.destroy
  end
end
