Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do
  tests "success" do
    tests "start api session" do
      response = Dynect[:dns].session
      returns(true) { response.body['Auth-Token'] =~ /.+=$/ && true }
      returns(true) { response.body['API-Version'] == "2.3.1" }
      returns(true) { response.status == 200 }
    end

    tests "list zones" do
      response = Dynect[:dns].zone
      returns(true) { response.body['zones'].first =~ /\.com/ && true }
      returns(true) { response.status == 200 }
    end

    tests "create record"
    tests "delete record"
    tests "update record"
    tests "list jobs"
  end
end
