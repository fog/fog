Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do
  tests( 'success') do
    test "start api session" do
      response = Dynect[:dns].session
      returns(true) { response.body['Auth-Token'] =~ /.+=$/ && true }
      returns(true) { response.body['API-Version'] == "2.3.1" }
      returns(true) { response.status == 200 }
    end

    test "list zones" do
      response = Dynect[:dns].zone
      returns(true) { response.body['zones'].size > 0 }
      returns(true) { response.status == 200 }
    end
  end
end
