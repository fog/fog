Shindo.tests('Fog::Rackspace::Queues | claims', ['rackspace']) do

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
    collection_tests(queue.claims, params)

    tests('creating claims when there are no messages') do

      before do
        #clear all message from queue
        queue.messages.all.each do |message|
          message.destroy
        end
      end

      tests("#create(#{params.inspect}) => with no messages does not show up in claim list") do
        returns(false) { queue.claims.create(params) }
        returns(true) { queue.claims.empty? }
      end
    end

    tests('create claims when there are messages') do

      before do
        queue.messages.create({
          :ttl => VALID_TTL,
          :body => { :random => :body }
        })
      end

      tests("#create(#{params.inspect}) => with messages does show up in claim list") do
        returns(true) do
          queue.claims.create(params).instance_of? Fog::Rackspace::Queues::Claim
        end
        returns(false) { queue.claims.empty? }
      end
    end
  ensure
    queue.destroy
  end
end
