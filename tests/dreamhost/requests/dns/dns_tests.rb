Shindo.tests('Fog::DNS[:dreamhost] | DNS requests', ['dreamhost', 'dns']) do

  # Create some domains for testing
  %w{one two three}.each do |dom|
    name = "#{dom}.fog-dream.com"
    type = "A"
    value = "1.2.3.4"
    comment = "test"
    response = Fog::DNS[:dreamhost].create_record(name, type, value, comment)
  end
  
  tests("success") do
    
    test("list records") do
      pending if Fog.mocking?

      response = Fog::DNS[:dreamhost].list_records

      if response.status == 200
        @records = response.body["data"]
      end

      (response.status == 200) and (response.body.size == 2)
    end
    
    test("list all the records") do
      pending if Fog.mocking?

      Fog::DNS[:dreamhost].records.all.size > 0
    end
    
    test("list records from existing zone") do
      pending if Fog.mocking?

      Fog::DNS[:dreamhost].records.all(:zone => 'fog-dream.com').size > 0
    end
    
    test("list records from nonexistent zone") do
      pending if Fog.mocking?

      Fog::DNS[:dreamhost].records.all(:zone => 'foozoone.local').size == 0
    end

    test("create an A resource record without comment") do
      pending if Fog.mocking?

      name = "foo.testing.fog-dream.com"
      type = "A"
      value = "1.2.3.4"
      response = Fog::DNS[:dreamhost].create_record(name, type, value)

      response.body['result'] == 'success'
    end
    
    test("create an A resource record with comment") do
      pending if Fog.mocking?

      name = "foo2.testing.fog-dream.com"
      type = "A"
      value = "1.2.3.4"
      comment = "test"
      response = Fog::DNS[:dreamhost].create_record(name, type, value, comment)
      
      response.body['result'] == 'success'
    end

    test("create TXT record") do
      pending if Fog.mocking?

      name = "txt.testing.fog-dream.com"
      type = "txt"
      value = "foobar"
      comment = "test"
      response = Fog::DNS[:dreamhost].create_record(name, type, value, comment)
      
      response.body['result'] == 'success'
    end

    test("TXT record found") do
      pending if Fog.mocking?

      rec = Fog::DNS[:dreamhost].records.get 'txt.testing.fog-dream.com'

      rec != nil
    end
    
    test("delete testing records") do
      pending if Fog.mocking?

      sleep 5

      success = true
      r = %w(
              foo.testing.fog-dream.com
              foo2.testing.fog-dream.com
              txt.testing.fog-dream.com
            )
      r.each do |rec|
        name = rec
        @records.each do |record|
          if record['record'] == name
            response = Fog::DNS[:dreamhost].delete_record(name, record["type"], record["value"])
            success = false if  (response.body['result'] != 'success')
          end
        end
      end

      success
    end
    

  end

  tests( 'failure') do
  end

  ## Cleanup
  Fog::DNS[:dreamhost].records.each do |r|
    r.destroy if r.name =~ /fog-dream.com/
  end

end
