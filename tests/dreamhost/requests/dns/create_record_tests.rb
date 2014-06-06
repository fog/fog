Shindo.tests('Fog::DNS[:dreamhost] | create_record request', ['dreamhost', 'dns']) do

  tests("success") do

    test("create an A resource record without comment") do
      name = "foo.testing.#{test_domain}"
      type = "A"
      value = "1.2.3.4"
      response = Fog::DNS[:dreamhost].create_record(name, type, value)

      response.body['result'] == 'success'
    end

    test("create an A resource record with comment") do
      name = "foo2.testing.#{test_domain}"
      type = "A"
      value = "1.2.3.4"
      comment = "test"
      response = Fog::DNS[:dreamhost].create_record(name, type, value, comment)

      response.body['result'] == 'success'
    end

    test("create TXT record") do
      name = "txt.testing.#{test_domain}"
      type = "txt"
      value = "foobar"
      comment = "test"
      response = Fog::DNS[:dreamhost].create_record(name, type, value, comment)

      response.body['result'] == 'success'
    end

  end

  # helper
  cleanup_records

end
