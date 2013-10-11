Shindo.tests('Fog::Rackspace::Queues | message', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Queues.new
  queue = service.queues.create({
    :name => "fog_instance_#{Time.now.to_i.to_s}",
  })
  options = {
    :ttl => VALID_TTL,
    :body => { :key => 'value' }
  }
  begin
    model_tests(queue.messages, options, false) do
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
end
