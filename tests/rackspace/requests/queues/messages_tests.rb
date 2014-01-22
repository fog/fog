Shindo.tests('Fog::Rackspace::Queues | messages_tests', ['rackspace']) do
  service = Fog::Rackspace::Queues.new

  queue_name = 'fog' + Time.now.to_i.to_s
  client_id = service.client_id
  message_id = nil

  service.create_queue(queue_name)

  begin
    tests('success') do
      tests("#list_message(#{client_id}, #{queue_name}, {:echo => true}) => No Content").returns(204) do
        service.list_messages(client_id, queue_name, {:echo => true}).status
      end

      tests("#create_message(#{client_id}, #{queue_name}, '{ :blah => 'blah' }', 300)").succeeds do
        response = service.create_message(client_id, queue_name, { :blah => 'blah' }, 300)
        message_id = response.body['resources'][0].split('/').last
      end

      tests("#list_message(#{client_id}, #{queue_name}, {:echo => true}) => With Content").formats(LIST_MESSAGES_FORMAT) do
        service.list_messages(client_id, queue_name, {:echo => true}).body
      end

      tests("#get_message(#{client_id}, #{queue_name}, #{message_id})").formats(MESSAGE_FORMAT) do
        service.get_message(client_id, queue_name, message_id).body
      end

      tests("#delete_message(#{queue_name}, #{message_id}, { :claim_id => '10' })").raises(Fog::Rackspace::Queues::ServiceError) do
        #API team should be changing this
        pending
        service.delete_message(queue_name, message_id, { :claim_id => '10' })
      end

      tests("#delete_message(#{queue_name}, #{message_id})").succeeds do
        service.delete_message(queue_name, message_id)
      end
    end

     tests('failure') do
       tests("#create_message('') => Invalid Create Critera").raises(Fog::Rackspace::Queues::BadRequest) do
         service.create_message(client_id, queue_name, '', 0)
       end

       tests("#get_message('queue_name', 'nonexistentmessage') => Does not exist").raises(Fog::Rackspace::Queues::NotFound) do
         service.get_message(client_id, queue_name, 'nonexistentmessage')
       end

     end
  ensure
    service.delete_queue(queue_name)
  end

end
