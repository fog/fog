Shindo.tests('Fog::Rackspace::Queues | message', ['rackspace']) do

  service = Fog::Rackspace::Queues.new
  queue = service.queues.create({
    :name => "fog_instance_#{Time.now.to_i.to_s}",
  })
  options = {
    :ttl => VALID_TTL,
    :body => { :key => 'value' }
  }
  begin
    model_tests(queue.messages, options) do
      tests('#href').returns(true) do
        !@instance.href.nil?
      end
      tests('#identity').returns(true) do
        !@instance.identity.nil?
      end
      tests('#save => Fails to update').raises(StandardError) do
        @instance.save
      end
    end

    message = queue.messages.create(options.merge({:claim_id => '10'}))
    tests('#destroy => fails if claim is not valid').raises(Fog::Rackspace::Queues::ServiceError) do
      #API team should be fixing this so that it errors in this scenario
      pending
      message.destroy
    end
  ensure
    queue.destroy
  end

  tests('identity') do
    tests('nil') do
      message = Fog::Rackspace::Queues::Message.new :href => nil
      returns(nil) { message.id }
    end
    tests('with claim id') do
      message = Fog::Rackspace::Queues::Message.new :href => '/v1/queues/queue1/messages/528b7e4bb04a584f2eb805a3?claim_id=528b7e6aef913e6d2977ee6d'
      returns('528b7e4bb04a584f2eb805a3') { message.id }
    end
    tests('without claim id') do
      message = Fog::Rackspace::Queues::Message.new :href => '/v1/queues/queue1/messages/528b7e4bb04a584f2eb805a3'
      returns('528b7e4bb04a584f2eb805a3') { message.id }
    end
  end

end
