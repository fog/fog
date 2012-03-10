Shindo.tests('Fog::DNS[:dreamhost] | DNS requests', ['dreamhost', 'dns']) do

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

      Fog::DNS[:dreamhost].records.all(:zone => 'rbel.co').size > 0
    end
    
    test("list records from nonexistent zone") do
      pending if Fog.mocking?

      Fog::DNS[:dreamhost].records.all(:zone => 'foozoone.local').size == 0
    end

    test("create an A resource record without comment") do
      pending if Fog.mocking?

      name = "foo.testing.rbel.co"
      type = "A"
      value = "1.2.3.4"
      response = Fog::DNS[:dreamhost].create_record(name, type, value)

      response.body['result'] == 'success'
    end
    
    test("create an A resource record with comment") do
      pending if Fog.mocking?

      name = "foo2.testing.rbel.co"
      type = "A"
      value = "1.2.3.4"
      comment = "test"
      response = Fog::DNS[:dreamhost].create_record(name, type, value, comment)
      
      response.body['result'] == 'success'
    end

    test("create TXT record") do
      pending if Fog.mocking?

      name = "txt.testing.rbel.co"
      type = "txt"
      value = "foobar"
      comment = "test"
      response = Fog::DNS[:dreamhost].create_record(name, type, value, comment)
      
      response.body['result'] == 'success'
    end

    test("TXT record found") do
      pending if Fog.mocking?

      rec = Fog::DNS[:dreamhost].records.get 'txt.testing.rbel.co'

      rec != nil
    end
    
    test("delete testing records") do
      pending if Fog.mocking?

      sleep 5

      success = true
      r = %w(
              foo.testing.rbel.co
              foo2.testing.rbel.co
              txt.testing.rbel.co
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

end
