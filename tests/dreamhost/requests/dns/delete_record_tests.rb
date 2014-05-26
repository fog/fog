Shindo.tests('Fog::DNS[:dreamhost] | delete_record request', ['dreamhost', 'dns']) do

  tests("success") do

    test("delete testing records") do
      name = "delete-test.#{test_domain}"
      type = "A"
      value = "1.2.3.4"
      comment = "test"
      Fog::DNS[:dreamhost].create_record(name, type, value, comment)
      response = Fog::DNS[:dreamhost].delete_record(name, type, value)
      response.body['result'] == 'success'
    end

  end

  tests( 'failure') do
    raises(RuntimeError, 'deleting non-existent record') do
      Fog::DNS[:dreamhost].delete_record('foo.bar.bar', 'A', '1.2.3.4')
    end
  end

  # helper
  cleanup_records

end
