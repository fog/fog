Shindo.tests('Fog::Rackspace::Queues | claim_tests', ['rackspace']) do

  service = Fog::Rackspace::Queues.new

  queue_name = 'fog' + Time.now.to_i.to_s
  client_id = service.client_id
  claim_id = nil

  service.create_queue(queue_name)

  tests('success') do

    tests("#create_claim(#{queue_name}, #{VALID_TTL}, #{VALID_GRACE}) => No Messages").returns(204) do
      service.create_claim(queue_name, VALID_TTL, VALID_GRACE).status
    end

    tests('with messages in the queue') do

      before do
        service.create_message(client_id, queue_name, { :message => "message-body"}, 300)
      end

      #TODO - Fix it so simple text bodies pass validation
      tests("#create_claim(#{queue_name}, #{VALID_TTL}, #{VALID_GRACE})").formats(CREATE_CLAIM_FORMAT) do
        response = service.create_claim(queue_name, VALID_TTL, VALID_GRACE)
        claim_id = response.headers['Location'].split('/').last
        response.body
      end

      tests("#get_claim(#{queue_name}, #{claim_id})").formats(CLAIM_FORMAT) do
        service.get_claim(queue_name, claim_id).body
      end

      tests("#update_claim(#{queue_name}, #{claim_id}, 500)").succeeds do
        service.update_claim(queue_name, claim_id, 500)
      end

      tests("#delete_claim(#{queue_name}, #{claim_id})").succeeds do
        service.delete_claim(queue_name, claim_id)
      end

      tests("#create_claim(#{queue_name}, #{VALID_TTL}, #{VALID_GRACE}, { :limit => 1})") do
        response = service.create_claim(queue_name, VALID_TTL, VALID_GRACE,  { :limit => 1})

        formats(CREATE_CLAIM_FORMAT) { response.body }
        returns(1) { response.body.length }
      end
    end
  end

  tests('failure') do
    tests("#get_claim('queue_name', 'nonexistentclaim') => Does not exist").raises(Fog::Rackspace::Queues::NotFound) do
      service.get_claim(queue_name, 'nonexistentclaim')
    end

  end

  service.delete_queue(queue_name)

end
